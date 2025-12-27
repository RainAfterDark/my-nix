#!/usr/bin/env bash

# ==========================================
# NixOS Interactive Installer
# ==========================================

# --- Configuration ---
TARGET_USER="ame" 
CONFIG_DIR_NAME="my-nix"

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
# Update this when adding new hosts!
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

# 4. Run Disko
# We use '.' to refer to the current directory (the git repo) as the flake
echo -e "\n${BLUE}:: Running Disko Partitioning... ::${NC}"
echo "You will now be asked to enter the LUKS password for encryption."
# Note: This requires disko to be in your flake inputs or run via github
sudo nix run github:nix-community/disko -- --mode disko --flake ".#${HOST}"

# 5. Install NixOS
echo -e "\n${BLUE}:: Installing NixOS... ::${NC}"
# --no-root-passwd: We set passwords manually later
sudo nixos-install --flake ".#${HOST}" --no-root-passwd

# 6. Copy Config to Target
echo -e "\n${BLUE}:: Cloning configuration to target machine... ::${NC}"
TARGET_DIR="/mnt/home/${TARGET_USER}/${CONFIG_DIR_NAME}"

# Create the parent directory
sudo mkdir -p "/mnt/home/${TARGET_USER}"

# Copy the current directory (the git repo) to the target
# We use rsync or cp. cp -r is standard.
sudo cp -r . "$TARGET_DIR"

# 7. Finalize Setup (Passwords & Permissions)
echo -e "\n${BLUE}:: Finalizing setup... ::${NC}"

# Set ownership of the home directory recursively
sudo nixos-enter --root /mnt -- bash -c "chown -R ${TARGET_USER}:users /home/${TARGET_USER}"

# Set the user password
# We use chpasswd which reads user:password from stdin
echo -e "\n${BLUE}:: Setting user password... ::${NC}"
sudo nixos-enter --root /mnt -- bash -c "echo '${TARGET_USER}:${USER_PASS}' | chpasswd"

echo -e "\n${GREEN}:: Installation Complete! ::${NC}"
echo -e "1. The system is installed."
echo -e "2. Your config is at: ~/nixos-config"
echo -e "3. You can now reboot."