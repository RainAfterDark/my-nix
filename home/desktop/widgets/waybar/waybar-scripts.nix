{ pkgs, host, ... }:
let
  cpuTempGlob =
    if host == "xps7590" then
      "/sys/devices/platform/coretemp.0/hwmon/hwmon*/temp1_input"
    else if host == "t14" then
      "/sys/class/hwmon/hwmon*/temp1_input"
    else
      "/sys/devices/pci0000:00/0000:00:18.3/hwmon/hwmon*/temp1_input";

  cpuPowerQuery =
    if host == "xps7590" then
      ''
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
      ''
    else if host == "t14" then
      ''
        watts="N/A"
        for hwmon in /sys/class/hwmon/hwmon*; do
          if [[ -r "$hwmon/name" ]]; then
            name=$(<"$hwmon/name")
            if [[ "$name" == "amdgpu" || "$name" == "zenpower" ]]; then
              if [[ -r "$hwmon/power1_average" ]]; then
                p=$(<"$hwmon/power1_average")
                watts=$(awk -v p="$p" 'BEGIN { printf "%04.1f", p / 1000000 }')
                break
              elif [[ -r "$hwmon/power1_input" ]]; then
                p=$(<"$hwmon/power1_input")
                watts=$(awk -v p="$p" 'BEGIN { printf "%04.1f", p / 1000000 }')
                break
              fi
            fi
          fi
        done
      ''
    else
      ''
        watts="N/A"
      '';

  waybarCpu = pkgs.writeShellScriptBin "waybar-cpu" ''
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
    temp=0
    for path in ${cpuTempGlob}; do
      if [[ -r "$path" ]]; then
        t=$(<"$path")
        temp=$((t / 1000))
        break # Stop after finding the first valid temp file
      fi
    done

    # CPU Power (Watts)
    ${cpuPowerQuery}

    # JSON Output
    jq --unbuffered --compact-output -n \
    --arg text "$usage%" \
    --arg tooltip "@''${freq}GHz ''${temp}°C ''${watts}W" \
    --argjson percentage "$usage" \
    '{text: $text, tooltip: $tooltip, percentage: $percentage}'
  '';

  waybarGpu = pkgs.writeShellScriptBin "waybar-gpu" (
    if host == "t14" then
      ''
        #!/usr/bin/env bash
        # AMD iGPU

        # Detect the card path (card0 or card1) that has the clock file
        CLOCK_FILE=$(ls /sys/class/drm/card*/device/pp_dpm_sclk 2>/dev/null | head -n 1)
        BUSY_FILE=$(ls /sys/class/drm/card*/device/gpu_busy_percent 2>/dev/null | head -n 1)

        # Parse Usage
        usage="0"
        if [[ -r "$BUSY_FILE" ]]; then
          usage=$(<"$BUSY_FILE")
        fi

        # Parse Clock (The line with the asterisk *)
        clock="0"
        if [[ -r "$CLOCK_FILE" ]]; then
          # Awk: Find line with *, remove "Mhz" from 2nd column, print it
          clock=$(awk '/\*/ { sub("Mhz", "", $2); print $2 }' "$CLOCK_FILE")
        fi

        # Parse Temp (Find the amdgpu hwmon)
        temp="0"
        for hwmon in /sys/class/hwmon/hwmon*; do
          if grep -q "amdgpu" "$hwmon/name" 2>/dev/null; then
               if [[ -r "$hwmon/temp1_input" ]]; then
                  t=$(<"$hwmon/temp1_input")
                  temp=$((t / 1000))
               fi
               break
          fi
        done

        # Parse Power (PPT)
        ${cpuPowerQuery}

        # JSON Output
        jq --unbuffered --compact-output -n \
          --arg text "''${usage}%" \
          --argjson percentage "$usage" \
          --arg tooltip "@''${clock}MHz ''${temp}°C ''${watts}W" \
          '{text: $text, percentage: $percentage, tooltip: $tooltip}'
      ''
    else
      ''
        #!/usr/bin/env bash
        # NVIDIA GPU

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
      ''
  );

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
  home.packages = [
    waybarCpu
    waybarGpu
    waybarPipewire
  ];
}
