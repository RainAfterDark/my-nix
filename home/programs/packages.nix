{ pkgs, ... }: {
  home.packages = with pkgs; [
    ### TUI
    ## Utilities
    duf # disk information
    eza # ls replacement
    fd # find replacement
    gping # ping with a graph
    gtrash # rm to system trash
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
    dex # util for desktop entries

    ## Monitoring / Fetch
    nitch # nice fetch
    fastfetch # not very fast, actually
    hyfetch # flagsssssssss
    onefetch # fetch utility for git repo

    ## Multimedia
    ani-cli # watch anime
    imv # image viewer
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

    handbrake # video remuxer
    sublime3 # text edit
    obsidian # notes vault
    warehouse # flatpak manager
    heroic # game launcher
    protonplus # wine and proton manager

    ### Custom Packaged
    my-scripts # Utility
  ];
}
