{ config, ... }:
{
  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "lock";
        action = "swaylock";
        text = "Lock";
        keybind = "1";
      }
      {
        label = "logout";
        action = "niri msg action quit -s";
        text = "Logout";
        keybind = "2";
      }
      {
        label = "reboot";
        action = "systemctl reboot --no-wall";
        text = "Reboot";
        keybind = "3";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff --no-wall";
        text = "Shutdown";
        keybind = "4";
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
      "Mod+Escape".action = onlyOne "wlogout" "-s -b 4";
    };
}
