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
          ioprio = 0;
        };

        gpu = {
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

  environment.systemPackages = with pkgs; [
    # GPU
    vulkan-tools # verify video
    libva-utils # verify vaapi
    mesa-demos # glxgears, etc.
    lact # GPU OC/UV

    # winediscordipcbridge-steam.sh
    pkgsCross.mingw32.wine-discord-ipc-bridge
  ];

  # Init start LACT
  systemd.services.lact = {
    description = "GPU Control Daemon";
    after = [ "multi-user.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.lact}/bin/lact daemon";
    };
    enable = true;
  };

  ## Enable NTSync for games
  boot.kernelModules = [ "ntsync" ];
}
