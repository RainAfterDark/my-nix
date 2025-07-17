{ pkgs, ... }:
{
  stylix.targets.swaylock = {
    enable = true;
    useWallpaper = false;
  };

  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      daemonize = true;
      ignore-empty-password = true;
      datestr = "賽は投げられた";
      font = "M PLUS 1 Code";
      font-size = 108;

      screenshots = true;
      clock = true;
      indicator = true;
      indicator-radius = 256;
      indicator-thickness = 16;

      effect-pixelate = 4;
      effect-blur = "8x6";
      effect-vignette = "0.42:0.69";
    };
  };
}
