#!/usr/bin/env bash

# ==========================================
# NixOS Interactive Installer
# ==========================================

# --- Configuration ---
TARGET_USER="ame"
CONFIG_DIR_NAME="my-nix"
SOPS_CONFIG_PATH="core/secrets/.sops.yaml" # Relative to git root

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

set -e # Exit immediately if a command exits with a non-zero status

# Ensure we are running from the git repo root
if [ ! -f "flake.nix" ]; then
    echo -e "${RED}Error: flake.nix not found. Please run this script from the root of your repository.${NC}"
    exit 1
fi

echo -e "${BLUE}:: NixOS Installer ::${NC}"

# 1. Select Host
echo -e "\n${GREEN}Which host config do you want to install?${NC}"
PS3="Select host (number): "
options=("desktop" "t14" "xps7590" "Quit")
select HOST in "${options[@]}"
do
    case $HOST in
        "desktop"|"t14"|"xps7590")
            echo -e "Selected Host: ${BLUE}${HOST}${NC}"
            break
            ;;
        "Quit")
            exit 0
            ;;
        *) echo "Invalid option $REPLY";;
    esac
done

# 2. Capture User Password
echo -e "\n${GREEN}Set password for user '${TARGET_USER}':${NC}"
while true; do
    read -s -p "Enter password: " USER_PASS
    echo
    read -s -p "Confirm password: " USER_PASS_CONFIRM
    echo
    [ "$USER_PASS" = "$USER_PASS_CONFIRM" ] && break
    echo -e "${RED}Passwords do not match. Try again.${NC}"
done

# 3. Confirmation
echo -e "\n${RED}WARNING: This will WIPE ALL DATA on the target drive.${NC}"
echo -e "You will be prompted for the LUKS (Disk Encryption) password during the partitioning step."
read -p "Are you sure you want to proceed? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
fi

# ==========================================
# SOPS Key Generation & Injection
# ==========================================
echo -e "\n${BLUE}:: Setting up SOPS Age Keys... ::${NC}"

KEY_DIR="$HOME/.config/sops/age"
KEY_FILE="$KEY_DIR/keys.txt"
mkdir -p "$KEY_DIR"

# Generate Key if missing
if [ ! -f "$KEY_FILE" ]; then
    echo "Generating new Age key for ${HOST}..."
    nix-shell -p age --run "age-keygen -o $KEY_FILE"
else
    echo "Existing Age key found at $KEY_FILE. Using it."
fi

# Extract Public Key
PUBLIC_KEY=$(grep "public key: age1" "$KEY_FILE" | awk '{print $4}')
echo "Public Key: $PUBLIC_KEY"

# Update .sops.yaml automatically
if [ -f "$SOPS_CONFIG_PATH" ]; then
    
    # Check if key already exists in config
    if grep -q "$PUBLIC_KEY" "$SOPS_CONFIG_PATH"; then
        echo "Key already exists in .sops.yaml."
    else
        echo "Injecting key into $SOPS_CONFIG_PATH..."
        echo "Backing up .sops.yaml..."
        cp "$SOPS_CONFIG_PATH" "${SOPS_CONFIG_PATH}.bak"
        
        # 1. Inject the key definition under 'keys:' (using perl for robust multiline replace)
        # Adds "- &hostname age1..." after "keys:"
        perl -i -pe "s/^keys:/keys:\n  - &${HOST} $PUBLIC_KEY/" "$SOPS_CONFIG_PATH"
        
        # 2. Inject the key reference into creation rules
        # Finds lines starting with "- *" (existing key refs) and appends the new one
        perl -i -pe "s/(- \*[a-zA-Z0-9_]+)$/\$1\n          - *${HOST}/" "$SOPS_CONFIG_PATH"
        
        echo "Key injected. Re-encrypting secrets..."
        
        # Re-encrypt all secrets.yaml files found in the repo
        find . -name "secrets.yaml" -print0 | while IFS= read -r -d '' secret_file; do
            echo "Updating keys for $secret_file..."
            nix-shell -p sops --run "sops updatekeys -y \"$secret_file\""
        done
    fi
else
    echo -e "${RED}Warning: SOPS config not found at $SOPS_CONFIG_PATH. Skipping SOPS setup.${NC}"
fi

# ==========================================
# Disko & Install
# ==========================================

# 4. Run Disko
echo -e "\n${BLUE}:: Running Disko Partitioning... ::${NC}"
echo "You will now be asked to enter the LUKS password for encryption."
sudo nix run --extra-experimental-features "nix-command flakes" github:nix-community/disko -- --mode disko --flake ".#${HOST}"

# 5. Manual Mount for Key Copying
# Ensure /mnt is mounted so we can copy the key before install
if ! mount | grep -q "/mnt "; then
    echo "Mounting partitions..."
    sudo nix run --extra-experimental-features "nix-command flakes" github:nix-community/disko -- --mode mount --flake ".#${HOST}"
fi

# 6. Copy Age Key to Target
# This is CRITICAL. NixOS activation will fail if this file is missing.
echo -e "\n${BLUE}:: Copying Age key to target... ::${NC}"
TARGET_KEY_DIR="/mnt/home/${TARGET_USER}/.config/sops/age"
sudo mkdir -p "$TARGET_KEY_DIR"
sudo cp "$KEY_FILE" "$TARGET_KEY_DIR/keys.txt"
# Set permissions: Owner read/write only (600). Owner will be fixed in step 9.
sudo chmod 600 "$TARGET_KEY_DIR/keys.txt"

# 7. Install NixOS
echo -e "\n${BLUE}:: Installing NixOS... ::${NC}"
sudo nixos-install --flake ".#${HOST}" --no-root-passwd --option experimental-features "nix-command flakes"

# 8. Copy Config to Target
echo -e "\n${BLUE}:: Cloning configuration to target machine... ::${NC}"
TARGET_DIR="/mnt/home/${TARGET_USER}/${CONFIG_DIR_NAME}"
sudo mkdir -p "/mnt/home/${TARGET_USER}"

# Copy the CURRENT directory (which has the modified .sops.yaml and secrets)
sudo cp -r . "$TARGET_DIR"

# 9. Finalize Setup
echo -e "\n${BLUE}:: Finalizing setup... ::${NC}"

# Chown home directory (recursively fixes ownership of config and keys)
sudo nixos-enter --root /mnt -- bash -c "chown -R ${TARGET_USER}:users /home/${TARGET_USER}"

# Set user password
echo -e "\n${BLUE}:: Setting user password... ::${NC}"
sudo nixos-enter --root /mnt -- bash -c "echo '${TARGET_USER}:${USER_PASS}' | chpasswd"

echo -e "\n${GREEN}:: Installation Complete! ::${NC}"