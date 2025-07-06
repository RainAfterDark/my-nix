{ config, pkgs, ... }:
{
  home.packages = with pkgs; [ swayosd ];

  programs.niri.settings = with config.lib.niri.actions; {
    spawn-at-startup = [
      { command = [ "swayosd-server" ]; }
    ];
    binds =
      let
        sh = spawn "sh" "-c";
      in
      {
        "XF86AudioRaiseVolume" = {
          action = sh "swayosd-client --output-volume +5 --max-volume=100";
          allow-when-locked = true;
        };
        "XF86AudioLowerVolume" = {
          action = sh "swayosd-client --output-volume -5";
          allow-when-locked = true;
        };
      };
  };
}
