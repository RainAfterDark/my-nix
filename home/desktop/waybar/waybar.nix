{
  pkgs,
  config,
  host,
  flakeRoot,
  ...
}:
let
  waybarDir = "${flakeRoot}/home/desktop/waybar";
  waybarSym = config.lib.file.mkOutOfStoreSymlink waybarDir;

  waybarCpu =
    let
      cpuTempPath =
        if host == "xps7590" then
          "/sys/devices/platform/coretemp.0/hwmon/hwmon7/temp1_input"
        else
          "/sys/devices/pci0000:00/0000:00:18.3/hwmon/hwmon0/temp1_input";
    in
    pkgs.writeShellScriptBin "waybar-cpu" ''
      #!/usr/bin/env bash

      # CPU Usage (%)
      read cpu user nice system idle rest < /proc/stat
      prev_total=$((user+nice+system+idle))
      prev_idle=$idle
      sleep 0.5
      read _ user nice system idle _ < /proc/stat
      total=$((user+nice+system+idle))
      idle_delta=$((idle - prev_idle))
      total_delta=$((total - prev_total))
      usage=$(( (100*(total_delta - idle_delta)) / total_delta ))

      # Max Core Frequency (GHz)
      max=0
      for f in /sys/devices/system/cpu/cpu[0-9]*/cpufreq/scaling_cur_freq; do
        if [[ -r "$f" ]]; then
          v=$(<"$f")
          (( v > max )) && max=$v
        fi
      done
      if (( max > 0 )); then
        freq=$(awk -v m="$max" 'BEGIN { printf "%03.1f", m / 1000000 }')
      else
        freq="0.00"
      fi

      # CPU Temp (°C)
      if [[ -r "${cpuTempPath}" ]]; then
        t=$(<"${cpuTempPath}")
        temp=$((t / 1000))
      else
        temp=0
      fi

      # CPU Power (Watts)
      rapl_path="/sys/class/powercap/intel-rapl:0/energy_uj"
      if [[ -r "$rapl_path" ]]; then
        e1=$(<"$rapl_path")
        sleep 0.1
        e2=$(<"$rapl_path")
        delta=$((e2 - e1))
        # µJ to Watts over 0.1s → W = (µJ / 1_000_000) / seconds
        watts=$(awk -v d="$delta" 'BEGIN { printf "%04.1f", d / 1000000 / 0.1 }')
      else
        watts="N/A"
      fi

      # JSON Output
      jq --unbuffered --compact-output -n \
      --arg text "$usage%" \
      --arg tooltip "@''${freq}GHz ''${temp}°C ''${watts}W" \
      --argjson percentage "$usage" \
      '{text: $text, tooltip: $tooltip, percentage: $percentage}'
    '';

  waybarGpu = pkgs.writeShellScriptBin "waybar-gpu" ''
    #!/usr/bin/env bash

    # Query GPU Stats
    IFS=',' read -r usage clock temp power <<< "$(
      nvidia-smi --query-gpu=utilization.gpu,clocks.gr,temperature.gpu,power.draw \
        --format=csv,noheader,nounits 2>/dev/null
    )"

    # Trim Whitespace
    usage=$(echo "$usage" | xargs)
    clock=$(echo "$clock" | xargs)
    temp=$(echo "$temp" | xargs)

    # Format Power
    watts=$(awk -v p="$power" 'BEGIN { printf "%04.1f", p }')

    # JSON Output
    jq --unbuffered --compact-output -n \
      --arg text "''${usage}%" \
      --argjson percentage "$usage" \
      --arg tooltip "@''${clock}MHz ''${temp}°C ''${watts}W" \
      '{text: $text, percentage: $percentage, tooltip: $tooltip}'
  '';

  waybarPipewire = pkgs.writeShellScriptBin "waybar-pipewire" ''
    #!/usr/bin/env bash
    set -e

    # https://blog.dhampir.no/content/sleeping-without-a-subprocess-in-bash-and-how-to-sleep-forever
    snore() {
        local IFS
        [[ -n "''${_snore_fd:-}" ]] || exec {_snore_fd}<> <(:)
        read -r ''${1:+-t "$1"} -u $_snore_fd || :
    }

    DELAY=0.2

    while snore $DELAY; do
        WP_OUTPUT=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)

        if [[ $WP_OUTPUT =~ ^Volume:[[:blank:]]([0-9]+)\.([0-9]{2})([[:blank:]].MUTED.)?$ ]]; then
            if [[ -n ''${BASH_REMATCH[3]} ]]; then
                printf "MUTE\n"
            else
                VOLUME=$((10#''${BASH_REMATCH[1]}''${BASH_REMATCH[2]}))
                ICON=(
                    ""
                    ""
                    ""
                )

                if [[ $VOLUME -gt 50 ]]; then
                    printf "%s" "''${ICON[0]}"
                elif [[ $VOLUME -gt 25 ]]; then
                    printf "%s" "''${ICON[1]}"
                elif [[ $VOLUME -ge 0 ]]; then
                    printf "%s" "''${ICON[2]}"
                fi

                printf " $VOLUME%%\n"
            fi
        fi
    done

    exit 0
  '';
in
{
  xdg.configFile."waybar" = {
    source = waybarSym;
    force = true;
  };

  home.packages = [
    waybarCpu
    waybarGpu
    waybarPipewire
  ];

  programs.waybar = {
    enable = true;
  };

  systemd.user.services.waybar = {
    Unit = {
      Description = "Waybar status bar";
      After = [ "niri.service" ];
    };
    Service = {
      ExecStart = "${pkgs.waybar}/bin/waybar";
    };
    Install = {
      WantedBy = [ "niri.service" ];
    };
  };

  systemd.user.services.waybar-reload = {
    Unit = {
      Description = "Fully restart Waybar on config change";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.systemd}/bin/systemctl --user restart waybar.service";
    };
  };

  systemd.user.paths.waybar-reload = {
    Unit = {
      Description = "Watch Waybar config folder for changes";
    };
    Path = {
      PathModified = waybarDir;
      Recursive = true;
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
