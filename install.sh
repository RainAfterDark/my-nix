#!/usr/bin/env bash

# ==========================================
# NixOS Interactive Installer
# ==========================================

# --- Configuration ---
TARGET_USER="ame"
CONFIG_DIR_NAME="my-nix"
SOPS_CONFIG_PATH="core/secrets/.sops.yaml"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

set -e

if [ ! -f "flake.nix" ]; then
    echo -e "${RED}Error: flake.nix not found. Run from repo root.${NC}"
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
        "Quit") exit 0 ;;
        *) echo "Invalid option $REPLY";;
    esac
done

# 2. Select Mode (Install vs Debug)
echo -e "\n${GREEN}Select Operation Mode:${NC}"
echo -e "1) ${RED}Full Install${NC} (Wipes disk, downloads cache, installs system)"
echo -e "2) ${YELLOW}Debug / Dry Run${NC} (Gen keys, update config, format disk, but SKIP install)"
read -p "Enter choice (1 or 2): " MODE_CHOICE

if [[ "$MODE_CHOICE" == "2" ]]; then
    DEBUG_MODE=true
    echo -e "${YELLOW}:: RUNNING IN DEBUG MODE - System will NOT be installed ::${NC}"
else
    DEBUG_MODE=false
fi

# 3. Capture Password
echo -e "\n${GREEN}Set password for user '${TARGET_USER}':${NC}"
while true; do
    read -s -p "Enter password: " USER_PASS
    echo
    read -s -p "Confirm password: " USER_PASS_CONFIRM
    echo
    [ "$USER_PASS" = "$USER_PASS_CONFIRM" ] && break
    echo -e "${RED}Mismatch. Try again.${NC}"
done

# ==========================================
# SOPS Automation
# ==========================================
echo -e "\n${BLUE}:: Setting up SOPS Age Keys... ::${NC}"

KEY_DIR="$HOME/.config/sops/age"
KEY_FILE="$KEY_DIR/keys.txt"
mkdir -p "$KEY_DIR"

if [ ! -f "$KEY_FILE" ]; then
    echo "Generating new Age key..."
    nix-shell -p age --run "age-keygen -o $KEY_FILE"
else
    echo "Existing Age key found."
fi

PUBLIC_KEY=$(grep "public key: age1" "$KEY_FILE" | awk '{print $4}')

if [ -f "$SOPS_CONFIG_PATH" ]; then
    # Check if key already exists in config
    if grep -q "$PUBLIC_KEY" "$SOPS_CONFIG_PATH"; then
        echo "Key already exists in .sops.yaml."
    else
        echo "Injecting key into $SOPS_CONFIG_PATH..."
        cp "$SOPS_CONFIG_PATH" "${SOPS_CONFIG_PATH}.bak"
        
        # 1. Inject the key definition
        # Matches "keys:" at the start of the line and appends the new key on the next line
        sed -i "s/^keys:/keys:\\n  - &${HOST} ${PUBLIC_KEY}/" "$SOPS_CONFIG_PATH"
        
        # 2. Inject the key reference
        # Matches any line ending with "- *something" and appends the new host reference
        sed -i -E "s/(- \*[a-zA-Z0-9_]+)$/\1\\n          - *${HOST}/" "$SOPS_CONFIG_PATH"
        
        echo "Key injected. Re-encrypting secrets..."
        
        # Re-encrypt all secrets.yaml files found in the repo
        find . -name "secrets.yaml" -print0 | while IFS= read -r -d '' secret_file; do
            echo "Updating keys for $secret_file..."
            nix-shell -p sops --run "sops updatekeys -y \"$secret_file\""
        done
    fi
else
    echo -e "${RED}Warning: $SOPS_CONFIG_PATH not found.${NC}"
fi

# 4. Confirmation
echo -e "\n${RED}WARNING: This will WIPE ALL DATA on the target drive.${NC}"
read -p "Are you sure you want to proceed? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then exit 1; fi

# ==========================================
# Disko & Mount
# ==========================================
echo -e "\n${BLUE}:: Running Disko... ::${NC}"
sudo nix run --extra-experimental-features "nix-command flakes" github:nix-community/disko -- --mode disko --flake ".#${HOST}"

# Ensure Mount
if ! mount | grep -q "/mnt "; then
    sudo nix run --extra-experimental-features "nix-command flakes" github:nix-community/disko -- --mode mount --flake ".#${HOST}"
fi

# ==========================================
# Copy Keys
# ==========================================
echo -e "\n${BLUE}:: Copying Age key to target... ::${NC}"
TARGET_KEY_DIR="/mnt/home/${TARGET_USER}/.config/sops/age"
sudo mkdir -p "$TARGET_KEY_DIR"
sudo cp "$KEY_FILE" "$TARGET_KEY_DIR/keys.txt"
sudo chmod 600 "$TARGET_KEY_DIR/keys.txt"
echo -e "Key placed at: ${GREEN}/mnt/home/${TARGET_USER}/.config/sops/age/keys.txt${NC}"

# ==========================================
# Install (or Skip)
# ==========================================
if [ "$DEBUG_MODE" = true ]; then
    echo -e "\n${YELLOW}:: DEBUG MODE :: Skipping nixos-install and user setup.${NC}"
    exit 0
fi

echo -e "\n${BLUE}:: Installing NixOS... ::${NC}"
sudo nixos-install --flake ".#${HOST}" --no-root-passwd --option experimental-features "nix-command flakes"

echo -e "\n${BLUE}:: Cloning configuration... ::${NC}"
TARGET_DIR="/mnt/home/${TARGET_USER}/${CONFIG_DIR_NAME}"
sudo mkdir -p "/mnt/home/${TARGET_USER}"
sudo cp -r . "$TARGET_DIR"

echo -e "\n${BLUE}:: Finalizing setup... ::${NC}"
sudo nixos-enter --root /mnt -- bash -c "chown -R ${TARGET_USER}:users /home/${TARGET_USER}"
sudo nixos-enter --root /mnt -- bash -c "echo '${TARGET_USER}:${USER_PASS}' | chpasswd"

echo -e "\n${GREEN}:: Installation Complete! ::${NC}"