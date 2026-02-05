{ pkgs, ... }:
let
  toggle-app = pkgs.writeShellScriptBin "toggle-app" ''
    #!/usr/bin/env bash

    # Usage:
    #   toggle_app name [args]

    APP_NAME="$1"
    LAUNCH_CMD="$APP_NAME $2"

    if pgrep $APP_NAME >/dev/null; then
      pkill $APP_NAME
    else
      setsid $LAUNCH_CMD >/dev/null 2>&1 &
    fi
  '';
in
{
  home.packages = [ toggle-app ];
}
