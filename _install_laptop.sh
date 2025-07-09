#!/usr/bin/env bash

sudo nix --experimental-features "nix-command flakes" \
  --option "extra-substituters" "https://chaotic-nyx.cachix.org/" \
  --option "extra-trusted-public-keys" "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8=" \
  run github:nix-community/disko/latest#disko-install -- \
  --write-efi-boot-entries \
  --flake /$HOME/my-nix#xps7590 \
  --disk main /dev/nvme0n1