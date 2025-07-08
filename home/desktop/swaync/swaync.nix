{ pkgs, ... }:
{
  home.packages = with pkgs; [ swaynotificationcenter ];

  programs.niri.settings.spawn-at-startup = [
    { command = [ "swaync" ]; }
  ];
}
