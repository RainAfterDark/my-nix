{ ... }:
{
  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "lock";
        action = "hyprlock";
        text = "Lock";
        keybind = "1";
      }
      {
        label = "suspend";
        action = "systemctl suspend";
        text = "Suspend";
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
}
