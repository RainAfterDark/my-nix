{ ... }:
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
        label = "reboot";
        action = "systemctl reboot --no-wall";
        text = "Reboot";
        keybind = "2";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff --no-wall";
        text = "Shutdown";
        keybind = "3";
      }
    ];
  };
}
