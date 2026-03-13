{
  lib,
  self,
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
      use-xdg-base-directories = true;

      trusted-users = [ username ];
      allowed-users = [ username ];

      experimental-features = [
        "nix-command"
        "flakes"
      ];
    }
    // (import ../flake.nix).nixConfig;

    # Allow system to be more responsive
    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";
    daemonIOSchedPriority = 7;

    # Use the same nixpkgs as in the system  flake
    registry.nixpkgs.flake = inputs.nixpkgs;
  };

  nixpkgs = import ./pkgs-opts.nix { inherit lib self; };

  _module.args.pkgs-stable = import inputs.nixpkgs-stable {
    system = pkgs.stdenv.hostPlatform.system;
    inherit (config.nixpkgs) config;
  };
}
