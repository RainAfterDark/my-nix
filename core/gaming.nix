{ inputs, pkgs, ... }:
{
  ## TODO: add Steam
  environment.systemPackages = with pkgs; [
    gamescope
    gamemode
  ];

  ## "Anime Games"
  imports = [ inputs.aagl.nixosModules.default ];
  programs.anime-game-launcher.enable = true;
  # programs.anime-games-launcher.enable = true;
  programs.honkers-railway-launcher.enable = true;
  # programs.honkers-launcher.enable = true;
  # programs.wavey-launcher.enable = true;
  # programs.sleepy-launcher.enable = true;
}
