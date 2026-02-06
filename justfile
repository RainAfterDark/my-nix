host := `hostname`
flake_root := "."
nh_flags := "--accept-flake-config"

# List available commands
default:
  @just --list

# Build and test new gen
test:
  @just _nhos "test" "Test"

# Build and switch new gen
switch:
  @just _nhos "switch" "Switch"

# Build as new boot gen
boot:
  @just _nhos "boot" "Boot"

# Update flake and run boot
update:
  @just _nhos "boot -u" "Update"

# Clean and keep 5 gens
clean:
  @just _notify "nh clean all --keep 5" "🧹 Nix Store Clean"

# Wrapper for NH OS switch commands
[private]
_nhos cmd desc:
  @just _notify "sudo nh os {{cmd}} -H {{host}} -R {{flake_root}} -- {{nh_flags}}" "❄️ NixOS {{desc}}"

# Wrapper to handle notifications/sounds
[private]
_notify cmd desc:
  #!/usr/bin/env sh
  cmd="{{cmd}}"
  desc="{{desc}}"

  # Run the command
  eval "$cmd"
  exit_code=$?

  if [ $exit_code -eq 0 ]; then
    notify-send -u normal "✅ Success" "$desc"
    canberra-gtk-play -i service-login > /dev/null 2>&1 &
  else
    notify-send -u critical "❌ Failed (exit $exit_code)" "$desc"
    canberra-gtk-play -i service-logout > /dev/null 2>&1 &
  fi
  
  exit $exit_code