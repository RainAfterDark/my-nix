{
  # config,
  inputs,
  lib,
  pkgs,
  username,
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

    ## SDDM w/ custome theme
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

    ## Power Management
    upower = {
      enable = true;
    };

    ## Bluetooth
    blueman.enable = true;

    ## Auto-login setup w/ greetd that starts niri-session
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

  # Clear cache before SDDM starts (need to apply theme somehow)
  systemd.services.sddm.serviceConfig.ExecStartPre = lib.mkAfter [
    "${pkgs.coreutils}/bin/rm -rf /var/lib/sddm/.cache"
  ];

  # To prevent getting stuck at shutdown
  systemd.extraConfig = "DefaultTimeoutStopSec=10s";
}
