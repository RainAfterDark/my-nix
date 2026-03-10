{ inputs, username, ... }:
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

    # Allow system to be more responsive
    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";
    daemonIOSchedPriority = 7;

    # Use the same nixpkgs as in the system  flake
    registry.nixpkgs.flake = inputs.nixpkgs;
  };
}
