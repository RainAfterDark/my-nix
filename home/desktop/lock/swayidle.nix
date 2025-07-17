{
  lib,
  pkgs,
  host,
  ...
}:
let
  lock = "${pkgs.swaylock-effects}/bin/swaylock";
  niriBin = "/run/current-system/sw/bin/niri";
  systemdBin = "/run/current-system/sw/bin/systemctl";
  monitors = status: "${niriBin} msg action power-${status}-monitors";
in
{
  services.swayidle = {
    enable = true;
    timeouts =
      [
        {
          timeout = 300; # 5:00
          command = lock;
        }
        {
          timeout = 330; # 5:30
          command = monitors "off";
        }
      ] # Sleep broken on deskop
      ++ lib.optional (host != "desktop") {
        timeout = 360; # 6:00
        command = "${systemdBin} sleep";
      };
    events = [
      {
        event = "before-sleep";
        command = lock;
      }
      {
        event = "after-resume";
        command = monitors "on";
      }
      {
        event = "lock";
        command = monitors "off" + "; " + lock;
      }
      {
        event = "unlock";
        command = monitors "on";
      }
    ];
  };
}
