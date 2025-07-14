#!/usr/bin/env bash
set -euo pipefail

# === Configuration ===
FLAKE_PATH=~/my-nix    # Path to your flake in the live USB
HOSTNAME=desktop       # Your flake system hostname
USER=ame               # Your NixOS user

# === Prompt for user password ===
echo "🔐 Enter password for user '$USER':"
read -s USER_PASSWORD
echo
echo "🔐 Confirm password:"
read -s USER_PASSWORD_CONFIRM
echo

if [[ "$USER_PASSWORD" != "$USER_PASSWORD_CONFIRM" ]]; then
  echo "❌ Passwords do not match. Aborting."
  exit 1
fi

# === Run nixos-install ===
echo "🚀 Installing NixOS..."
sudo nixos-install \
  --flake "$FLAKE_PATH#$HOSTNAME" \
  --no-root-password \
  --option extra-substituters 'https://chaotic-nyx.cachix.org/' \
  --option extra-trusted-public-keys 'chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8='

# === Post-install: finalize setup ===
echo "🛠  Finalizing user setup..."
sudo nixos-enter <<EOF
# Set user password
echo "$USER:$USER_PASSWORD" | chpasswd

# Move flake from /etc/nixos → user's home
mv /etc/nixos /home/$USER/my-nix
chown -R $USER:users /home/$USER/my-nix
EOF

echo "✅ NixOS installed successfully! You can now reboot and log in as '$USER'."
