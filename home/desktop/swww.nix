{ pkgs, ... }:
{
  home.packages = with pkgs; [ swww ];
  programs.niri.settings = {
    spawn-at-startup = [
      { command = [ "swww-daemon" ]; }
    ];
  };
}
