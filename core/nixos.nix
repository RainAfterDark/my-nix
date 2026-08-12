{
  inputs,
  pkgs,
  flakeRoot,
  ...
}:
{
  imports = [ inputs.nix-index-database.nixosModules.default ];

  environment.systemPackages = with pkgs; [
    nix-output-monitor # nom
    nix-tree # browse store
    nurl # fetch hashes
    nvd # nix diff tool
  ];

  programs = {
    # Nix CLI Tool
    nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep-since 7d --keep 5";
      };
      flake = flakeRoot;
    };

    # Nix develop
    direnv = {
      enable = true;
      settings = {
        global = {
          strict_env = true;
          warn_timeout = 0;
          hide_env_diff = true;
        };
      };
    };

    # Run nixpkgs anywhere with ','
    nix-index-database.comma.enable = true;
  };

  ## Dynamic libraries needed by some programs
  # https://github.com/NixOS/nixpkgs/issues/240444#issuecomment-1988645885
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    gtk3
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
    glew_1_10
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
    libice
    libsm
    libx11
    libxscrnsaver
    libxcomposite
    libxcursor
    libxdamage
    libxext
    libxfixes
    libxft
    libxi
    libxinerama
    libxmu
    libxrandr
    libxrender
    libxt
    libxtst
    libxxf86vm
    libpciaccess
    libxcb
    libxcb-util
    libxcb-image
    libxcb-keysyms
    libxcb-render-util
    libxcb-wm
    xkeyboard-config
    xz
    zlib
  ];
}
