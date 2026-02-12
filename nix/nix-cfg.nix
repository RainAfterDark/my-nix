{
  lib,
  pkgs,
  config,
  inputs,
  username,
  ...
}:
{
  nix = {
    settings = {
      sandbox = true;
      auto-optimise-store = true;
      trusted-users = [ username ];
      allowed-users = [ username ];

      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

    registry.nixpkgs.flake = inputs.nixpkgs;
  };

  nixpkgs = {
    overlays = [
      inputs.nix-cachyos-kernel.overlays.pinned
      inputs.niri.overlays.niri
      (import ../pkgs/overlays.nix)
    ];

    config =
      let
        pkgPred = list: (pkg: builtins.elem (lib.getName pkg) list);
      in
      {
        allowInsecurePredicate = pkgPred [ "ventoy-gtk3" ];
        # using predicate here would be nice, but there's way too much...
        allowUnfree = true;
        nvidia.acceptLicense = true;
        android_sdk.accept_license = true;
      };
  };

  _module.args.pkgs-stable = import inputs.nixpkgs-stable {
    system = pkgs.stdenv.hostPlatform.system;
    inherit (config.nixpkgs) config;
  };
}
