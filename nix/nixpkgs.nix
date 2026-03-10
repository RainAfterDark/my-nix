{
  lib,
  self,
  pkgs,
  inputs,
  config,
  ...
}:
{
  nixpkgs = import ./pkgs-opts.nix { inherit lib self; };
  _module.args.pkgs-stable = import inputs.nixpkgs-stable {
    system = pkgs.stdenv.hostPlatform.system;
    inherit (config.nixpkgs) config;
  };
}
