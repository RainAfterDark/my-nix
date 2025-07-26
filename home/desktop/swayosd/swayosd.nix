{ config, flakeRoot, ... }:
{
  ## DEPRECATED: Slow resource hog I was never satisfied with, using syshud instead.
  # services.swayosd = {
  #   enable = true;
  #   stylePath = "${flakeRoot}/home/desktop/swayosd/swayosd-style.css";
  # };

  # programs.niri.settings = with config.lib.niri.actions; {
  #   binds =
  #     let
  #       sh = spawn "sh" "-c";
  #       mkVolumeAction = v: {
  #         action = sh "swayosd-client --output-volume ${v} --max-volume=100";
  #         allow-when-locked = true;
  #         cooldown-ms = 25;
  #       };
  #       mkBrightnessAction = v: {
  #         action = sh "swayosd-client --brightness ${v}";
  #         allow-when-locked = true;
  #         cooldown-ms = 25;
  #       };
  #     in
  #     {
  #       "XF86AudioRaiseVolume" = mkVolumeAction "+10";
  #       "XF86AudioLowerVolume" = mkVolumeAction "-10";
  #       "Mod+TouchpadScrollDown" = mkVolumeAction "+10";
  #       "Mod+TouchpadScrollUp" = mkVolumeAction "-10";

  #       "XF86MonBrightnessUp" = mkBrightnessAction "raise";
  #       "XF86MonBrightnessDown" = mkBrightnessAction "lower";
  #       "Mod+Alt+TouchpadScrollDown" = mkBrightnessAction "raise";
  #       "Mod+Alt+TouchpadScrollUp" = mkBrightnessAction "lower";
  #     };
  # };
}
