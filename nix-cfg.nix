{
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
      inputs.nix-cachyos-kernel.overlay
      inputs.niri.overlays.niri
      (import ./pkgs/overlays.nix)
    ];

    config = {
      permittedInsecurePackages = [
        "ventoy-gtk3-1.1.10"
      ];
      allowUnfree = true;
      nvidia.acceptLicense = true;
      android_sdk.accept_license = true;
    };
  };

  _module.args.pkgs-stable = import inputs.nixpkgs-stable {
    inherit (pkgs) system;
    inherit (config.nixpkgs) config;
  };
}
