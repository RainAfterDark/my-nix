{ inputs, ... }:
{
  programs = {
    gamescope = {
      enable = true;
      capSysNice = true;
    };
    gamemode = {
      enable = true;
      enableRenice = true;
    };
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      gamescopeSession.enable = true;
    };
  };

  ## "Anime Games"
  imports = [ inputs.aagl.nixosModules.default ];
  programs.anime-game-launcher.enable = true;
  # programs.anime-games-launcher.enable = true;
  programs.honkers-railway-launcher.enable = true;
  # programs.honkers-launcher.enable = true;
  # programs.wavey-launcher.enable = true;
  # programs.sleepy-launcher.enable = true;
}
