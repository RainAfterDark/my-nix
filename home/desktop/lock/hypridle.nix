{
  lib,
  pkgs,
  host,
  ...
}:
let
  hyprlock = "${pkgs.hyprlock}/bin/hyprlock";
  niri = "/run/current-system/sw/bin/niri";
  sleepOnBat = pkgs.writeShellScript "sleep-on-bat" ''
    # Check if AC is online (1 = plugged in, 0 = battery)
    ac_status=$(${pkgs.coreutils}/bin/cat /sys/class/power_supply/AC/online)   
    if [ "$ac_status" = "0" ]; then
      /run/current-system/sw/bin/systemctl suspend
    fi
  '';
in
{
  services.hypridle = {
    enable = true;

    settings = {
      general = {
        # Avoid starting multiple hyprlock instances
        lock_cmd = "pidof hyprlock || ${hyprlock}";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "${niri} msg action power-on-monitors";
      };

      listener = [
        {
          timeout = 300; # 5:00
          on-timeout = "${niri} msg action power-off-monitors";
          on-resume = "${niri} msg action power-on-monitors";
        }
      ]
      # Laptop-only rules
      ++ lib.optionals (host != "desktop") [
        {
          timeout = 330; # 5:30
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 360; # 6:00
          on-timeout = "${sleepOnBat}";
        }
      ];
    };
  };

  # Fix hyprlock ran in hypridle not being able to call date
  systemd.user.services.hypridle.Service.Environment = lib.mkForce "PATH=${
    lib.makeBinPath [
      pkgs.coreutils
      pkgs.bash
    ]
  }:/run/current-system/sw/bin";
}
