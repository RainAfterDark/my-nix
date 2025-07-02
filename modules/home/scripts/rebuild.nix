{
  pkgs,
  host,
  username,
  flakeRoot,
  ...
}:
{
  home.packages =
    let
      device = "${username}@${host}";
    in
    [
      (pkgs.writeShellScriptBin "nox" ''
        #!/usr/bin/env bash
        set -euo pipefail

        start=$(date +%s)
        cd "${flakeRoot}"

        cmd_system=(sudo nh os switch -H ${host} -R ${flakeRoot} "$@")
        cmd_home=(nh home switch \
        ${flakeRoot}#homeConfigurations.${device}.activationPackage "$@")

        # Temporary stderr logs
        log_system="/tmp/nox-system-$RANDOM.err"
        log_home="/tmp/nox-home-$RANDOM.err"

        # Temporary wrapper scripts
        wrapper_system=$(mktemp --suffix=.sh)
        wrapper_home=$(mktemp --suffix=.sh)
        chmod +x "$wrapper_system" "$wrapper_home"

        # Wrapper script for system
        cat <<EOF > "$wrapper_system"
        #!/usr/bin/env bash
        set -euo pipefail
        script -q -c "''${cmd_system[*]}" "$log_system"
        EOF

        # Wrapper script for home
        cat <<EOF > "$wrapper_home"
        #!/usr/bin/env bash
        set -euo pipefail
        ''${cmd_home[*]} 2> >(tee "$log_home" >&2)
        EOF

        spawn_kitty() {
          tmp_socket="/tmp/nox_kitty_$$"

          # Start kitty and run system switch
          kitty -o allow_remote_control=yes \
                --listen-on "unix:$tmp_socket" \
                --title "nh-os" \
                bash "$wrapper_system" \
                >/dev/null 2>&1 &
          pid_system=$!

          # Wait until the socket responds
          for i in {1..30}; do
            if kitty @ --to "unix:$tmp_socket" ls >/dev/null 2>&1; then break; fi
            sleep 0.1
          done

          if ! kitty @ --to "unix:$tmp_socket" ls >/dev/null 2>&1; then
            echo "❌ Kitty control socket never became ready: $tmp_socket" >&2
            kill $pid_system 2>/dev/null || true
            exit 1
          fi

          export KITTY_LISTEN_ON="unix:$tmp_socket"
        }

        split_kitty() {
          # Start home-manager switch on a second pane
          kitty @ --to="$KITTY_LISTEN_ON" launch \
                --type=window \
                --cwd="$PWD" \
                --location=hsplit \
                --title="nh-home" \
                bash "$wrapper_home" \
                >/dev/null 2>&1 &
          pid_home=$!
        }

        have_kitty() { command -v kitty >/dev/null 2>&1; }

        show_clean_log() {
          local label="$1"
          local file="$2"
          echo "$label logs:"
          if grep -q '^Script started' "$file" && grep -q '^Script done' "$file"; then
            sed '1d;$d' "$file"
          else
            cat "$file"
          fi
        }

        # Main
        if have_kitty; then
          echo "❄️ Building Nix configuration for ${device}:"
          if printf '%s\n' "$@" | grep -q -- '--update'; then
            echo "⚠️ Updating flake, running sequentially…"
            "''${cmd_system[@]}"
            echo
            "''${cmd_home[@]}"
          else
            spawn_kitty
            split_kitty
            wait "$pid_system" "$pid_home"
            echo
            show_clean_log "🖥️ System" "$log_system"
            show_clean_log "🏠 Home" "$log_home"
          fi
        else
          echo "🐱 Please install kitty!"
        fi

        rm -f "$wrapper_system" "$wrapper_home" "$log_system" "$log_home"

        if have_kitty; then
          end=$(date +%s)
          elapsed=$(( end - start ))
          echo
          printf "✅ Finished in %02dm%02ds\n" $((elapsed/60)) $((elapsed%60))
        fi
      '')
    ];
}
