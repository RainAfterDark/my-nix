{ inputs, pkgs, ... }:
{
  ## Steam
  programs = {
    gamescope = {
      enable = true;
      capSysNice = true;
    };

    gamemode = {
      enable = true;
      enableRenice = true;

      settings = {
        general = {
          renice = 10;
        };

        gpu = {
          apply_gpu_optimisations = "accept-responsibility";
          gpu_device = 0;
          nv_powermizer_mode = 1;
          amd_performance_level = "high";
        };
      };
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

  ## Enable NTSync for games
  boot.kernelModules = [ "ntsync" ];

  ## winediscordipcbridge-steam.sh
  environment.systemPackages = with pkgs; [
    pkgsCross.mingw32.wine-discord-ipc-bridge
  ];
}
