{ inputs, lib }:
lib.composeManyExtensions [
  inputs.nix-cachyos-kernel.overlays.pinned
  inputs.niri.overlays.niri

  (
    final: prev:
    import ../pkgs {
      pkgs = final;
      # Prevent infinite recursion
      lib = prev.lib;
      inherit prev inputs;
    }
  )
]
