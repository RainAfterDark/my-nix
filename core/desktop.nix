{
  inputs,
  lib,
  pkgs,
  config,
  username,
  ...
}:
let
  autoLogin = true;
  systemTheme = "kanagawa-dragon";
in
{
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

    # SDDM custom theme
    inputs.sddm-stray-nixos.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  services = {
    # Input
    xserver = {
      enable = true;
      xkb.layout = "us";
    };

    libinput = {
      enable = true;
    };

    # GNOME
    dbus.packages = with pkgs; [
      gcr
      gnome-settings-daemon
      libsecret
    ];

    dbus.enable = true;
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;

    # SDDM w/ custom theme (not used)
    displayManager = {
      defaultSession = "niri";
      sddm = {
        enable = !autoLogin;
        theme = "sddm-stray-nixos";
        package = pkgs.kdePackages.sddm;
        extraPackages = with pkgs; [
          kdePackages.qtsvg
          kdePackages.qtmultimedia
        ];

        # wayland is bugged with an external monitor
        wayland.enable = false;
        settings = {
          General = {
            # disable virtual keyboard
            InputMethod = "";
          };
        };

        # hack to focus primary screen
        setupScript =
          let
            xdotool = "${pkgs.xdotool}/bin/xdotool";
          in
          lib.mkIf (!autoLogin) ''
            (
              ${xdotool} mousemove --screen 0 0 1080
              ${xdotool} click --repeat 10 --delay 100 1
            ) &
          '';
      };
    };

    # Auto-login setup w/ greetd that starts niri-session
    displayManager.autoLogin = {
      enable = autoLogin;
      user = "${username}";
    };

    greetd =
      let
        niri-pkg = config.programs.niri.package;
        session = {
          command = "${niri-pkg}/bin/niri-session";
          user = "${username}";
        };
      in
      {
        enable = autoLogin;
        settings = {
          terminal.vt = 1;
          default_session = session;
          initial_session = session;
        };
      };
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
  };

  qt.enable = true;
}
