{ inputs, lib, ... }:
lib.composeManyExtensions [
  inputs.nix-cachyos-kernel.overlays.pinned
  inputs.niri.overlays.niri
  (import ../pkgs { inherit inputs lib; }).overlay
]
