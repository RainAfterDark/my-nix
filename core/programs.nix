{
  pkgs,
  username,
  ...
}:
{
  # GNOME
  programs.dconf.enable = true;

  # Enable zsh system-wide so it can be set for user
  programs.zsh.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    # pinentryFlavor = "";
  };

  # Nix CLI Tool
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 7d --keep 5";
    };
    flake = "/home/${username}/my-nix";
  };

  ## System Utilities
  environment.systemPackages = with pkgs; [
    coreutils # essentials
    binutils # packaging
    pciutils # lspci, etc.
    tmux # the one and only
    ventoy-full-gtk # USB ISO

    # GPU
    vulkan-tools
    mesa-demos
    lact # GPU OC/UV

    # Nix
    nix-output-monitor # nom
    nvd # nix diff tool

    # Hardware
    wev # input tester
    lm_sensors # motherboard sensors
    compsize # compute BTRFS compression ratio
    via # keyboard remapper
    smartmontools # drive S.M.A.R.T

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
    adwaita-icon-theme
  ];

  # Init start LACT
  systemd.services.lact = {
    description = "GPU Control Daemon";
    after = [ "multi-user.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.lact}/bin/lact daemon";
    };
    enable = true;
  };

  # Allow VIA through udev
  services.udev.packages = with pkgs; [ via ];

  # Enable Flatpaks
  services.flatpak.enable = true;

  # Shebangs ibuprofen
  services.envfs.enable = true;

  # Enable smartd service from smartmontools
  services.smartd.enable = true;

  # ADB for Android development
  programs.adb.enable = true;

  # Allow running AppImage
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  # Wireshark
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
    dumpcap.enable = true;
    usbmon.enable = true;
  };

  # VM
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
      };
    };
    spiceUSBRedirection.enable = true;
    docker = {
      enable = true;
      autoPrune.enable = true;
    };
  };
  services.spice-vdagentd.enable = true;

  ## Dynamic libraries needed by some programs
  # https://github.com/NixOS/nixpkgs/issues/240444#issuecomment-1988645885
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    SDL
    SDL2
    SDL2_image
    SDL2_mixer
    SDL2_ttf
    SDL_image
    SDL_mixer
    SDL_ttf
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    bzip2
    cairo
    cups
    curlWithGnuTls
    dbus
    dbus-glib
    desktop-file-utils
    e2fsprogs
    expat
    flac
    fontconfig
    freeglut
    freetype
    fribidi
    fuse
    fuse3
    gdk-pixbuf
    glew110
    glib
    gmp
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-ugly
    gst_all_1.gstreamer
    gtk2
    harfbuzz
    icu
    keyutils.lib
    libGL
    libGLU
    libappindicator-gtk2
    libcaca
    libcanberra
    libcap
    libclang.lib
    libdbusmenu
    libdrm
    libgcrypt
    libgpg-error
    libidn
    libjack2
    libjpeg
    libmikmod
    libogg
    libpng12
    libpulseaudio
    librsvg
    libsamplerate
    libthai
    libtheora
    libtiff
    libudev0-shim
    libusb1
    libuuid
    libvdpau
    libvorbis
    libvpx
    libxcrypt-legacy
    libxkbcommon
    libxml2
    mesa
    nspr
    nss
    openssl
    p11-kit
    pango
    pixman
    python3
    speex
    stdenv.cc.cc
    tbb
    udev
    vulkan-loader
    wayland
    xorg.libICE
    xorg.libSM
    xorg.libX11
    xorg.libXScrnSaver
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXft
    xorg.libXi
    xorg.libXinerama
    xorg.libXmu
    xorg.libXrandr
    xorg.libXrender
    xorg.libXt
    xorg.libXtst
    xorg.libXxf86vm
    xorg.libpciaccess
    xorg.libxcb
    xorg.xcbutil
    xorg.xcbutilimage
    xorg.xcbutilkeysyms
    xorg.xcbutilrenderutil
    xorg.xcbutilwm
    xorg.xkeyboardconfig
    xz
    zlib
  ];
}
