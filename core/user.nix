{
  lib,
  pkgs,
  config,
  inputs,
  host,
  username,
  flakeRoot,
  stateVersion,
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
    extraSpecialArgs = {
      inherit
        inputs
        host
        username
        flakeRoot
        colors
        ;
    };

    users.${username} = {
      imports = findModules ./../home;
      home.username = "${username}";
      home.homeDirectory = "/home/${username}";
      home.stateVersion = stateVersion;
      programs.home-manager.enable = true;
    };
  };

  users.users.${username} = {
    isNormalUser = true;
    description = "${username}";
    extraGroups = [
      "wheel"
      "docker"
      "networkmanager"
    ];
    shell = pkgs.zsh;
  };
}
