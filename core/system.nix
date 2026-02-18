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

  # Clear cache before SDDM starts (need to apply theme somehow)
  systemd.services.sddm.serviceConfig.ExecStartPre = lib.mkAfter [
    "${pkgs.coreutils}/bin/rm -rf /var/lib/sddm/.cache"
  ];

  # To prevent getting stuck at shutdown
  systemd.settings.Manager.DefaultTimeoutStopSec = "10s";

  system.stateVersion = "25.11";
}
