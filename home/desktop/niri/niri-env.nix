{
  lib,
  pkgs,
  ...
}:
let
  environment = {
    CLUTTER_BACKEND = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland";
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
    inherit environment;

    spawn-at-startup = [
      # { command = [ "mpvpaper-loop" ]; }
      { command = [ "syshud" ]; }
      { command = [ "zen-beta" ]; }
      { command = [ "spotify" ]; }
      { command = [ "vesktop" ]; }
    ];

    xwayland-satellite = {
      enable = true;
      path = lib.getExe pkgs.xwayland-satellite-unstable;
    };

    prefer-no-csd = true;
    hotkey-overlay.skip-at-startup = true;
  };
}
