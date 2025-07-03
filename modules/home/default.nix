{ username, ... }:
{
  imports = [
    ./desktop
    ./develop
    ./programs
    ./scripts
    ./terminal
    ./theme
  ];

  programs.home-manager.enable = true;

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.11";
  };
}
