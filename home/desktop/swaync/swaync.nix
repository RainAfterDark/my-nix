{
  pkgs,
  config,
  flakeRoot,
  ...
}:
let
  swayNcDir = "${flakeRoot}/home/desktop/swaync";
  swayNcSym = config.lib.file.mkOutOfStoreSymlink swayNcDir;
in
{
  home.packages = with pkgs; [ swaynotificationcenter ];

  xdg.configFile."swaync" = {
    source = swayNcSym;
    force = true;
  };

  programs.niri.settings.spawn-at-startup = [
    { command = [ "swaync" ]; }
  ];
}
