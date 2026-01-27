{
  lib,
  pkgs,
  host,
  config,
  ...
}:
let
  environment = {
    _JAVA_AWT_WM_NONREPARENTING = "1";
    CLUTTER_BACKEND = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    ELECTRON_ENABLE_HARDWARE_ACCELERATION = "1";
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "niri";
  };
in
{
  home.sessionVariables = environment;

  programs.niri.settings = {
    environment = lib.mapAttrs (k: v: toString v) config.home.sessionVariables;

    spawn-at-startup = [
      { command = [ "syshud" ]; }
      { command = [ "zen-beta" ]; }
    ];

    xwayland-satellite = {
      enable = true;
      path = lib.getExe pkgs.xwayland-satellite-unstable;
    };

    # Make touch display work for Thinkpad
    input.touch.map-to-output = lib.mkIf (host == "t14") "eDP-1";

    debug = {
      # This acts as a compatibility shim for Firefox/Zen focus issues
      honor-xdg-activation-with-invalid-serial = true;
    };

    prefer-no-csd = true;
    hotkey-overlay.skip-at-startup = true;
  };
}
