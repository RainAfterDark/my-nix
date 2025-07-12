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
