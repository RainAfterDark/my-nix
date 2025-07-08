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
      onlyOne = c: f: sh "flock -n /tmp/${c}.lock sh -c '${c} ${f}'";
    in
    {
      "Mod+Escape".action = onlyOne "wlogout" "-s";
    };
}
