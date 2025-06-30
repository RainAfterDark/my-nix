{
  config,
  inputs,
  lib,
  pkgs,
  username,
  ...
}:
{
  environment.systemPackages = [
    inputs.sddm-stray-nixos.packages.${pkgs.system}.default
  ];

  services = {
    xserver = {
      enable = true;
      xkb.layout = "us";
    };

    libinput = {
      enable = true;
    };

    # needed for GNOME services outside of GNOME Desktop
    dbus.packages = with pkgs; [
      gcr
      gnome-settings-daemon
      libsecret
    ];
    dbus.enable = true;

    gnome.gnome-keyring.enable = true;

    gvfs.enable = true;

    displayManager = {
      defaultSession = "niri";
      sddm = {
        enable = true;
        package = pkgs.kdePackages.sddm;
        extraPackages = with pkgs; [
          kdePackages.qtsvg
          kdePackages.qtmultimedia
        ];
        wayland.enable = true;
        theme = "sddm-stray-nixos";
      };
    };

    ## Auto-Login Setup that starts niri-session
    # displayManager.autoLogin = {
    #   enable = true;
    #   user = "${username}";
    # };
    # greetd =
    #   let
    #     niri-pkg = config.programs.niri.package;
    #     session = {
    #       command = "${niri-pkg}/bin/niri-session";
    #       user = "${username}";
    #     };
    #   in
    #   {
    #     enable = true;
    #     settings = {
    #       terminal.vt = 1;
    #       default_session = session;
    #       initial_session = session;
    #     };
    #   };
  };

  # To prevent getting stuck at shutdown
  systemd.extraConfig = "DefaultTimeoutStopSec=10s";

  # Clear cache before SDDM starts (need to apply theme somehow)
  systemd.services.sddm.serviceConfig.ExecStartPre = lib.mkAfter [
    "${pkgs.coreutils}/bin/rm -rf /var/lib/sddm/.cache"
  ];
}
