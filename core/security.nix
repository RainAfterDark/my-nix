{ pkgs, username, ... }:
{
  security = {
    ## Use sudo rust rewrite
    sudo.enable = false;
    sudo-rs = {
      enable = true;
      # QoL for config rebuilds
      extraRules = [
        {
          users = [ username ];
          commands =
            let
              mkNoPassPair = name: [
                {
                  command = "${pkgs.${name}}/bin/${name}";
                  options = [ "NOPASSWD" ];
                }
                {
                  command = "/run/current-system/sw/bin/${name}";
                  options = [ "NOPASSWD" ];
                }
              ];
            in
            builtins.concatLists (
              builtins.map mkNoPassPair [
                "nh"
                "nix"
                "nixos-rebuild"
              ]
            )
            ++ [
              {
                command = "/nix/store/*/bin/switch-to-configuration";
                options = [ "NOPASSWD" ];
              }
            ];
        }
      ];
    };

    # For realtime scheduling
    rtkit.enable = true;
    # Unlock GPG keyring on login for greetd
    pam.services.greetd.enableGnomeKeyring = true;
  };
}
