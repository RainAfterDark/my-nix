{
  pkgs,
  config,
  flakeRoot,
  ...
}:
let
  waybarDir = "${flakeRoot}/home/desktop/waybar";
  waybarSym = config.lib.file.mkOutOfStoreSymlink waybarDir;
  waybarHr = pkgs.writeShellScriptBin "waybar-hr" ''
    #!/usr/bin/env bash
    pkill -SIGUSR2 waybar || waybar &
    fd . ${waybarDir} -tf |
    entr -s 'pkill -SIGUSR2 waybar || waybar &'
  '';
in
{
  xdg.configFile."waybar" = {
    source = waybarSym;
    force = true;
  };

  home.packages = [ waybarHr ];

  programs.waybar = {
    enable = true;
  };

  programs.niri.settings.spawn-at-startup = [
    { command = [ "waybar" ]; }
  ];
}
