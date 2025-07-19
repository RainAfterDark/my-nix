{ pkgs, config, ... }:
let
  fontFamily = config.stylix.fonts.monospace.name;
in
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
      datestr = "lock tf in";
      font = fontFamily;
      font-size = 80;

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
