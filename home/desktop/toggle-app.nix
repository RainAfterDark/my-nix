{ pkgs, ... }:
let
  toggle-app = pkgs.writeShellScriptBin "toggle-app" ''
    #!/usr/bin/env bash
    # bash

    # Usage:
    #   toggle_app name [args]

    APP_NAME="$1"
    shift

    if pgrep $APP_NAME >/dev/null; then
      pkill $APP_NAME
    else
      setsid "$APP_NAME" "$@" >/dev/null 2>&1 &
    fi
  '';
in
{
  home.packages = [ toggle-app ];
}
