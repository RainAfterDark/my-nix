{ config, ... }:
{
  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "logout";
        action = "niri msg action quit -s";
        text = "Logout";
        keybind = "l";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
    ];
  };

  programs.niri.settings.binds =
    with config.lib.niri.actions;
    let
      sh = spawn "sh" "-c";
      onlyOne = f: sh "flock -n /tmp/${f}.lock ${f}";
    in
    {
      "Mod+Escape".action = onlyOne "wlogout";
    };
}
