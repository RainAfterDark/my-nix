{
  lib,
  pkgs,
  host,
  ...
}:
let
  lock = "${pkgs.hyprlock}/bin/hyprlock";
  niriBin = "/run/current-system/sw/bin/niri";
  systemdBin = "/run/current-system/sw/bin/systemctl";
  monitors = status: "${niriBin} msg action power-${status}-monitors";

  suspendScript = pkgs.writeShellScript "suspend-check" ''
    # Check if AC is online (1 = plugged in, 0 = battery)
    ac_status=$(${pkgs.coreutils}/bin/cat /sys/class/power_supply/AC/online)   
    if [ "$ac_status" = "0" ]; then
      ${systemdBin} suspend
    fi
  '';
  sleepOnBat = "${suspendScript}";
in
{
  ## DEPRECATED! in favor of hypridle

  services.swayidle = {
    enable = false;
    timeouts = [
      {
        timeout = 300; # 5:00
        command = monitors "off";
      }
    ]
    # Lock only on laptops
    ++ lib.optional (host != "desktop") {
      timeout = 330; # 5:30
      command = lock;
    }
    # Sleep broken on deskop
    ++ lib.optional (host != "desktop") {
      timeout = 360; # 6:00
      command = sleepOnBat;
    };
    events = {
      "before-sleep" = lock;
      "after-resume" = monitors "on";
      "lock" = monitors "off" + "; " + lock;
      "unlock" = monitors "on";
    };
  };
}
