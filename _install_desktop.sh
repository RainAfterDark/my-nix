#!/usr/bin/env bash
set -euo pipefail

USER=ame
REPO_PATH=~/my-nix
TARGET_PATH=/mnt/home/$USER/my-nix
SUB_URL="https://chaotic-nyx.cachix.org/"
SUB_KEY="chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="

# Install system
echo "🚀 Running nixos-install..."
sudo nixos-install --flake "$REPO_PATH#desktop" --no-root-password \
  --option extra-substituters "$SUB_URL" \
  --option extra-trusted-public-keys "$SUB_KEY"

# Interactive password for user
sudo nixos-enter <<EOF
echo "Please enter password for user '$USER':"
passwd $USER
EOF

# Copy flake repo into new user's home directory
echo "📁 Copying flake repo into $TARGET_PATH..."
sudo mkdir -p "$TARGET_PATH"
sudo cp -r "$REPO_PATH"/* "$TARGET_PATH"
# Assuming UID:GID is 1000:100
sudo chown -R 1000:100 "$TARGET_PATH"

echo "✅ Install complete! You can now reboot."
