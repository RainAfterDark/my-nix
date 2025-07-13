{
  pkgs,
  inputs,
  host,
  username,
  flakeRoot,
  stateVersion,
  homeModules,
  ...
}:
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
        ;
    };

    users.${username} = {
      imports = homeModules;
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
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
  };
}
