{
  lib,
  pkgs,
  username,
  ...
}:
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
              map mkNoPassPair [
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

    # Unlock GPG keyring on login for greetd
    pam.services.greetd.enableGnomeKeyring = true;
    # For swaylock login
    pam.services.swaylock = { };
  };

  # Replace polkit-kde-agent set by niri-flake with polkit-gnome
  systemd.user.services.niri-flake-polkit = {
    serviceConfig.ExecStart = lib.mkForce "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
  };
}
