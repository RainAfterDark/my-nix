{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ### TUI
    ## Better core utils
    duf # disk information
    eza # ls replacement
    fd # find replacement
    gping # ping with a graph
    gtrash # rm replacement, put deleted files in system trash
    hevi # hex viewer
    hexyl # hex viewer
    man-pages # extra man pages
    ncdu # disk space
    ripgrep # grep replacement
    tldr # zoomer man
    bat # zoomer cat

    ## Monitoring / Fetch
    nitch
    fastfetch
    hyfetch
    onefetch # fetch utility for git repo
    wavemon # monitoring for wireless network devices

    ## Fun / Testing
    smassh # typing test in the terminal
    toipe # typing test in the terminal
    ttyper # cli typing test
    asciiquarium-transparent
    cbonsai
    cmatrix
    countryfetch
    cowsay
    figlet
    fortune
    lavat
    lolcat
    pipes
    sl
    tty-clock

    ## Multimedia
    ani-cli
    imv
    lowfi
    presenterm

    ## Utilities
    entr # perform action when file change
    ffmpeg-full
    file # Show file information
    jq # JSON processor
    killall
    libnotify
    libcanberra-gtk3
    openssl
    pamixer # pulseaudio command line mixer
    playerctl # controller for media players
    unzip
    wget
    md-tui

    ### GUI
    pavucontrol # Audio Control
    libreoffice # Documents etc.
    mission-center # GUI Resources Monitor
    qbittorrent # Torrent Client
    gimp3-with-plugins # Image Manipulation
    obsidian # Notes Vault
    warehouse # Flatpak Manager
    heroic # Game Launcher
    handbrake # Video Remuxer
    waypaper # Wallpaper Picker in Python
    hardinfo2 # Hardware Info

    ### Custom Packaged
    hellpaper # Wallpaper Picker in Raylib
  ];
}
