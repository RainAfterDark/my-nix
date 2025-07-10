{ inputs, pkgs, ... }:
{
  ## System-wide installs for desktop programs
  # Niri
  imports = [ inputs.niri.nixosModules.niri ];
  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };

  environment.systemPackages = with pkgs; [
    # Display Manager stuff
    cage
    gamescope
    wayland-utils
    wl-clipboard
    xwayland-satellite-unstable

    # For SDDM/Quickshell
    qt6.full
    kdePackages.qtbase
    kdePackages.qtdeclarative

    # Quickshell
    (inputs.quickshell.packages.${pkgs.system}.default.override {
      withX11 = false;
      withHyprland = false;
      withI3 = false;
    })
  ];

  qt.enable = true;

  environment.sessionVariables = {
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    ELECTRON_ENABLE_HARDWARE_ACCELERATION = "1";
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";

    CLUTTER_BACKEND = "wayland";
    SDL_VIDEODRIVER = "wayland";
    GDK_BACKEND = "wayland,x11";
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config = {
      common = {
        default = [
          "gnome"
          "gtk"
        ];
        "org.freedesktop.impl.portal.ScreenCast" = "gnome";
        "org.freedesktop.impl.portal.Screenshot" = "gnome";
        "org.freedesktop.impl.portal.RemoteDesktop" = "gnome";
      };
    };
    extraPortals = with pkgs; [
      xdg-desktop-portal
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
  };
}
