{
  config,
  pkgs,
  username,
  ...
}:
{
  services = {
    xserver = {
      enable = true;
      xkb.layout = "us";
    };

    libinput = {
      enable = true;
    };

    displayManager.autoLogin = {
      enable = true;
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
        enable = true;
        settings = {
          terminal.vt = 1;
          default_session = session;
          initial_session = session;
        };
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
  };

  # To prevent getting stuck at shutdown
  systemd.extraConfig = "DefaultTimeoutStopSec=10s";
}
