{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    syshud
  ];

  programs.niri.settings = {
    spawn-at-startup = [
      { command = [ "syshud" ]; }
    ];
    binds =
      with config.lib.niri.actions;
      let
        volumeStep = "10";
        brightnessStep = "10";

        mkControlAction = a: {
          action = spawn "sh" "-c" a;
          allow-when-locked = true;
        };

        volume = v: mkControlAction "pamixer ${v}";
        volumeUp = volume "-i ${volumeStep}";
        volumeDown = volume "-d ${volumeStep}";

        brightness = v: mkControlAction "brightnessctl set ${v}";
        brightnessUp = brightness "+${brightnessStep}%";
        brightnessDown = brightness "${brightnessStep}%-";
      in
      {
        "XF86AudioRaiseVolume" = volumeUp;
        "XF86AudioLowerVolume" = volumeDown;
        "Mod+TouchpadScrollDown" = volumeUp;
        "Mod+TouchpadScrollUp" = volumeDown;

        "XF86MonBrightnessUp" = brightnessUp;
        "XF86MonBrightnessDown" = brightnessDown;
        "Mod+Alt+TouchpadScrollDown" = brightnessUp;
        "Mod+Alt+TouchpadScrollUp" = brightnessDown;
      };
  };
}
