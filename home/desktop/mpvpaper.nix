{ pkgs, flakeRoot, ... }:
let
  bg = "clementine.mp4";
  bgPath = "${flakeRoot}/assets/${bg}";
  flags = "no-audio --loop=inf";
in
{
  home.packages = with pkgs; [ mpvpaper ];
  programs.niri.settings = {
    spawn-at-startup = [
      {
        command = [
          "sh"
          "-c"
          ''mpvpaper -o "${flags}" ALL ${bgPath}''
        ];
      }
    ];
  };
}
