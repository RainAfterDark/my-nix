{
  lib,
  pkgs,
  pkgs-stable,
  config,
  inputs,
  host,
  username,
  flakeRoot,
  ...
}:
let
  inherit (lib) findModules extendedColors;
  fromStylix = config.lib.stylix.colors.withHashtag;
  colors = extendedColors fromStylix;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "hmbak";

    extraSpecialArgs = {
      inherit
        inputs
        pkgs-stable
        host
        username
        colors
        ;
    };

    users.${username} = {
      imports = findModules ./../home;
      home = {
        username = "${username}";
        homeDirectory = "/home/${username}";
        stateVersion = config.system.stateVersion;
        sessionVariables = {
          FLAKE_ROOT = flakeRoot;
        };
      };
    };
  };

  users.users.${username} = {
    isNormalUser = true;
    description = "${username}";
    extraGroups = [
      "wheel"
      "docker"
      "kvm"
      "adbusers"
      "libvirtd"
      "wireshark"
      "networkmanager"
      "gamemode"
    ];
    shell = pkgs.zsh;
  };

  environment.pathsToLink = [ "/share/zsh" ];
}
