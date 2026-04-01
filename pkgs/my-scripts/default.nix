{ pkgs, ... }:
pkgs.symlinkJoin {
  name = "my-scripts";
  paths = [
    (pkgs.writeShellApplication {
      name = "toggle-app";
      runtimeInputs = [ pkgs.procps ];
      text = ''
        APP_NAME="$1"
        shift

        if pgrep "$APP_NAME" >/dev/null; then
          pkill "$APP_NAME"
        else
          # Using nohup or setsid to ensure the app outlives the script
          setsid "$APP_NAME" "$@" >/dev/null 2>&1 &
        fi
      '';
    })

    (pkgs.writeShellApplication {
      name = "sleep-on-bat";
      runtimeInputs = [
        pkgs.systemd
        pkgs.gnugrep
      ];
      text = ''
        if grep -q "Discharging" /sys/class/power_supply/BAT*/status 2>/dev/null; then
          systemctl suspend
        fi
      '';
    })
  ];
}
