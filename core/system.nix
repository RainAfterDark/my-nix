{
  inputs,
  config,
  lib,
  pkgs,
  username,
  stateVersion,
  ...
}:
let
  autoLogin = true;
in
{
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto;
  # boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;

  ## Needed to allow debugging
  boot.kernel.sysctl = {
    "kernel.kptr_restrict" = 0;
    "kernel.perf_event_paranoid" = 1;
  };

  ## SDDM Stray theme
  environment.systemPackages = [
    inputs.sddm-stray-nixos.packages.${pkgs.system}.default
  ];

  services = {
    ## sched-ext
    scx = {
      enable = true;
      scheduler = "scx_lavd";
      extraArgs = [ "--autopower" ];
    };

    ## Input
    xserver = {
      enable = true;
      xkb.layout = "us";
    };
    libinput = {
      enable = true;
    };

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

    ## [DESKTOP] Auto-login setup w/ greetd that starts niri-session
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

  # Clear cache before SDDM starts (need to apply theme somehow)
  systemd.services.sddm.serviceConfig.ExecStartPre = lib.mkAfter [
    "${pkgs.coreutils}/bin/rm -rf /var/lib/sddm/.cache"
  ];

  # To prevent getting stuck at shutdown
  systemd.settings.Manager.DefaultTimeoutStopSec = "10s";

  system.stateVersion = stateVersion;
}
