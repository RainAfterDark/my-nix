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
        mkVolumeAction = v: {
          action = sh "swayosd-client --output-volume ${v} --max-volume=100";
          allow-when-locked = true;
          cooldown-ms = 100;
        };
        mkBrightnessAction = v: {
          action = sh "swayosd-client --brightness ${v}";
          allow-when-locked = true;
          cooldown-ms = 100;
        };
      in
      {
        "XF86AudioRaiseVolume" = mkVolumeAction "+10";
        "XF86AudioLowerVolume" = mkVolumeAction "-10";
        "Mod+TouchpadScrollDown" = mkVolumeAction "+10";
        "Mod+TouchpadScrollUp" = mkVolumeAction "-10";

        "XF86MonBrightnessUp" = mkBrightnessAction "raise";
        "XF86MonBrightnessDown" = mkBrightnessAction "lower";
        "Mod+Alt+TouchpadScrollDown" = mkBrightnessAction "raise";
        "Mod+Alt+TouchpadScrollUp" = mkBrightnessAction "lower";
      };
  };
}
