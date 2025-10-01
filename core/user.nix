{
  lib,
  pkgs,
  pkgs-stable,
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
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.nixowos.nixosModules.default
  ];
  nixowos.enable = true;

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit
        inputs
        pkgs-stable
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
      "kvm"
      "adbusers"
      "libvirtd"
      "wireshark"
    ];
    shell = pkgs.zsh;
  };
}
