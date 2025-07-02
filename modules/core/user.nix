{
  pkgs,
  # host,
  # inputs,
  username,
  # flakeRoot,
  ...
}:
{
  # imports = [ inputs.home-manager.nixosModules.home-manager ];

  # home-manager = {
  #   useUserPackages = true;
  #   useGlobalPkgs = true;
  #   extraSpecialArgs = {
  #     inherit
  #       host
  #       inputs
  #       username
  #       flakeRoot
  #       ;
  #   };
  #   users.${username} = {
  #     imports = [ ./../home ];
  #     home.username = "${username}";
  #     home.homeDirectory = "/home/${username}";
  #     home.stateVersion = "25.11";
  #     programs.home-manager.enable = true;
  #   };
  # };

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
