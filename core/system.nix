{ lib, pkgs, ... }:
{
  # Needed to allow debugging
  boot.kernel.sysctl = {
    "kernel.kptr_restrict" = 0;
    "kernel.perf_event_paranoid" = 1;
  };

  environment.systemPackages = with pkgs; [
    # Core
    coreutils # essentials
    binutils # packaging
    pciutils # lspci, etc.
    android-tools # ADB, etc.
    tmux # terminal multiplexer

    # Hardware
    wev # input tester
    lm_sensors # motherboard sensors
    compsize # compute BTRFS compression ratio
    via # keyboard remapper
    smartmontools # drive S.M.A.R.T
    usbutils # lsusb, etc.
    libinput # Input devices

    # VM
    virt-manager
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    virtio-win
    win-spice
    libguestfs-with-appliance

    # Benchmark
    geekbench
    stress-ng
    s-tui

    # Misc.
    freetype # font engine
    adwaita-icon-theme # "default" icons
    ventoy-full-gtk # USB ISO
  ];

  programs = {
    # GNOME settings
    dconf.enable = true;

    # Enable zsh system-wide so it can be set for user
    zsh.enable = true;

    # GnuPG
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    # Allow running AppImage
    appimage = {
      enable = true;
      binfmt = true;
    };
  };

  services = {
    # Allow VIA through udev
    udev.packages = with pkgs; [ via ];

    # Power Management
    upower.enable = true;

    # Enable Flatpaks
    flatpak.enable = true;

    # Shebangs ibuprofen
    envfs.enable = true;

    # Enable smartd service from smartmontools
    smartd.enable = true;

    # For virt.
    spice-vdagentd.enable = true;
  };

  # VM
  virtualisation = {
    spiceUSBRedirection.enable = true;

    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
      };
    };

    docker = {
      enable = true;
      autoPrune.enable = true;
    };
  };

  # Time / Locales
  time.timeZone = "Asia/Manila";
  i18n = {
    defaultLocale = "en_PH.UTF-8";

    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "en_PH.UTF-8/UTF-8"
      "tl_PH.UTF-8/UTF-8"
      "ja_JP.UTF-8/UTF-8"
    ];

    extraLocaleSettings = {
      LC_ADDRESS = "en_PH.UTF-8";
      LC_IDENTIFICATION = "en_PH.UTF-8";
      LC_MEASUREMENT = "en_PH.UTF-8";
      LC_MONETARY = "en_PH.UTF-8";
      LC_NAME = "en_PH.UTF-8";
      LC_NUMERIC = "en_PH.UTF-8";
      LC_PAPER = "en_PH.UTF-8";
      LC_TELEPHONE = "en_PH.UTF-8";
      LC_TIME = "en_PH.UTF-8";
    };
  };

  # To prevent getting stuck at shutdown
  systemd.settings.Manager.DefaultTimeoutStopSec = "10s";

  system.stateVersion = "25.11";
}
