{ pkgs, ... }:
let
  backlight-timeout = pkgs.writeShellApplication {
    name = "backlight-timeout";

    runtimeInputs = with pkgs; [
      evtest
      brightnessctl
      coreutils
    ];

    text = ''
      # bash
      # Configuration
      TIMEOUT=5
      DEVICE="tpacpi::kbd_backlight"

      # Helper to get max brightness
      MAX=$(brightnessctl -d "$DEVICE" m)

      echo "Starting keyboard backlight manager..."

      # Ensure light is off initially so we start in a known state
      brightnessctl -d "$DEVICE" set 0 > /dev/null
      CURRENT_STATE="off"

      # 1. evtest monitors devices
      # 2. grep filters for Key (1) or Mouse (2) activity
      # 3. while loop handles the logic
      for dev in /dev/input/event*; do
        evtest "$dev" &
      done | stdbuf -oL grep -E "type (1|2)" | while true; do
        
        if [ "$CURRENT_STATE" = "on" ]; then
            # We wait for input, BUT we give up after $TIMEOUT seconds.
            if read -r -t "$TIMEOUT" _; then
                # 0.1s debounce
                sleep 0.1
                # flush events that piled up after sleep
                while read -r -t 0 _; do read -r _; done
                continue
            else
                # Timeout reached! Turn light OFF.
                brightnessctl -d "$DEVICE" set 0 > /dev/null
                CURRENT_STATE="off"
            fi
        
        else
            # We wait indefinitely for input.
            if read -r _; then
                # Input received! Turn light ON.
                brightnessctl -d "$DEVICE" set "$MAX" > /dev/null
                CURRENT_STATE="on"
            else
                # 'read' failed without timeout (EOF)? Input stream died.
                echo "Input stream closed. Exiting."
                break
            fi
        fi
        
      done
    '';
  };
in
{
  environment.systemPackages = with pkgs; [
    evtest
    brightnessctl
  ];

  systemd.services.kbd-backlight-auto = {
    description = "Reactive Keyboard Backlight Daemon";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${backlight-timeout}/bin/backlight-timeout";
      Restart = "always";
      User = "root";
    };
  };
}
