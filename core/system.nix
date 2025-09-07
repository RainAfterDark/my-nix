{
  inputs,
  config,
  lib,
  pkgs,
  host,
  username,
  stateVersion,
  ...
}:
{
  ## Use the CachyOS patched kernel
  imports = [ inputs.chaotic.nixosModules.default ];
  boot.kernelPackages = pkgs.linuxPackages_cachyos;

  ## SDDM Stray theme
  environment.systemPackages = [
    inputs.sddm-stray-nixos.packages.${pkgs.system}.default
  ];

  services = {
    ## CachyOS sched-ext
    # by default uses scx_rustland scheduler
    scx.enable = true;

    ## Input
    xserver = {
      enable = true;
      xkb.layout = "us";
    };
    libinput = {
      enable = true;
    };

    ## Preload
    preload.enable = true;

    ## GNOME stuff
    dbus.packages = with pkgs; [
      gcr
      gnome-settings-daemon
      libsecret
    ];
    dbus.enable = true;
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;

    ## Power Management
    upower = {
      enable = true;
    };

    ## [LAPTOP] SDDM w/ custom theme
    displayManager = {
      defaultSession = "niri";
      sddm = {
        enable = host == "xps7590";
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
          lib.mkIf (host == "xps7590") ''
            (
              ${xdotool} mousemove --screen 0 0 1080
              ${xdotool} click --repeat 10 --delay 100 1
            ) &
          '';
      };
    };

    ## [DESKTOP] Auto-login setup w/ greetd that starts niri-session
    displayManager.autoLogin = {
      enable = host == "desktop";
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
        enable = host == "desktop";
        settings = {
          terminal.vt = 1;
          default_session = session;
          initial_session = session;
        };
      };
  };

  # Clear cache before SDDM starts (need to apply theme somehow)
  systemd.services.sddm.serviceConfig.ExecStartPre = lib.mkAfter [
    "${pkgs.coreutils}/bin/rm -rf /var/lib/sddm/.cache"
  ];

  # To prevent getting stuck at shutdown
  systemd.settings.Manager.DefaultTimeoutStopSec = "10s";

  system.stateVersion = stateVersion;
  nixowos.enable = true;
}
