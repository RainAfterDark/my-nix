{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ### TUI
    ## Utilities
    duf # disk information
    eza # ls replacement
    fd # find replacement
    gping # ping with a graph
    gtrash # put deleted files in system trash
    man-pages # extra man pages
    ncdu # disk space
    ripgrep # grep replacement
    tlrc # zoomer man
    bat # zoomer cat
    entr # perform action when file change
    file # Show file information
    jq # JSON processor
    killall # process killer
    libnotify # send notifications to daemon
    libcanberra-gtk3 # system sounds
    openssl # SSL and TLS
    unzip # archives
    wget # downloader
    navi # interactive cheatsheet

    ## Monitoring / Fetch
    nitch # nice fetch
    fastfetch # not very fast, actually
    hyfetch # flagsssssssss
    onefetch # fetch utility for git repo
    wavemon # wireless network monitor

    ## Fun
    smassh # monkeytype
    toipe # typing test
    asciiquarium-transparent # fish
    cbonsai # tree
    cmatrix # 1337 haxor
    figlet # ascii text
    fortune # pseudorandom
    lavat # laval lamp
    pipes # plumbing
    sl # choo choo

    ## Multimedia
    ani-cli # watch anime
    imv # image viewer
    lowfi # lo-fi beats
    presenterm # md presentation
    md-tui # markdown parser
    ffmpeg-full # video manipulation
    playerctl # for MRPIS players
    pamixer # pulseaudio command line mixer

    ### GUI
    pavucontrol # audio control
    libreoffice # documents and office
    mission-center # resources monitor
    qbittorrent # torrent client
    hardinfo2 # hardware info
    qdirstat # visualize disk usage

    gimp3-with-plugins # image manipulation
    krita # drawing and painting
    handbrake # video remuxer
    kdePackages.kdenlive # video editor
    vlc # media player

    obsidian # notes vault
    warehouse # flatpak manager
    heroic # game launcher
    protonplus # wine and proton manager
    mcaselector # minecraft worlds util
    waypaper # wallpaper picker in python

    ### Custom Packaged
    hellpaper # wallpaper picker in C (raylib)
  ];
}
