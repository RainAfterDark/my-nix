{ inputs, pkgs, ... }:
let
  systemTheme = "tomorrow-night";
in
{
  ## System-wide installs for desktop programs
  imports = [
    inputs.niri.nixosModules.niri
    inputs.stylix.nixosModules.stylix
  ];

  programs.niri = {
    enable = true;
    package =
      let
        niri-base = pkgs.niri-unstable;
        # Silence the deprecated import-environment warning
        niri-patched = pkgs.symlinkJoin {
          inherit (niri-base)
            meta
            pname
            version
            passthru
            cargoBuildFeatures
            cargoBuildNoDefaultFeatures
            ;

          name = "niri-patched";
          paths = [ niri-base ];
          buildInputs = [ pkgs.makeWrapper ];
          postBuild = ''
            rm $out/bin/niri-session
            cp ${niri-base}/bin/niri-session $out/bin/niri-session
            sed -i 's|systemctl --user import-environment|systemctl --user import-environment 2> /dev/null|' $out/bin/niri-session
            chmod +x $out/bin/niri-session
          '';
        };
      in
      niri-patched;
  };

  stylix = {
    enable = true;
    autoEnable = false;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/${systemTheme}.yaml";
  };

  environment.systemPackages = with pkgs; [
    # Display Manager stuff
    wayland-utils
    wl-clipboard
    xwayland-satellite-unstable

    # For QT things (SDDM, etc.)
    kdePackages.qtbase
    kdePackages.qtdeclarative

    # Quickshell (one day I will use you...)
    # (inputs.quickshell.packages.${pkgs.system}.default.override {
    #   withX11 = false;
    #   withHyprland = false;
    #   withI3 = false;
    # })
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
