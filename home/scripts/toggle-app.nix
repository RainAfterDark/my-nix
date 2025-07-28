{ pkgs, ... }:
let
  toggle-app = pkgs.writeShellScriptBin "toggle-app" ''
    #!/usr/bin/env bash

    # Usage:
    #   toggle_app app_name [launch_command]
    # If launch_command is not provided, defaults to app_name

    APP_NAME="$1"
    LAUNCH_CMD="''${2:-$APP_NAME}"

    if pgrep -fx "$LAUNCH_CMD" >/dev/null; then
      pkill -fx "$LAUNCH_CMD"
    else
      setsid $LAUNCH_CMD >/dev/null 2>&1 &
    fi
  '';
in
{
  home.packages = [ toggle-app ];
}
