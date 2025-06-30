{ pkgs, ... }:
{
  home.packages = with pkgs; [
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
    tldr
    bat

    ## Tools / useful cli
    # aoc-cli                           # Advent of Code command-line tool
    # asciinema
    # asciinema-agg
    # binsider
    # bitwise                           # cli tool for bit / hex manipulation
    # broot                             # tree files view
    # caligula                          # User-friendly, lightweight TUI for disk imaging
    # hyperfine                         # benchmarking tool
    # pastel                            # cli to manipulate colors
    # swappy                            # snapshot editing tool
    # tdf                               # cli pdf viewer
    # tokei                             # project line counter
    # translate-shell                   # cli translator
    # woomer
    # yt-dlp-light

    ## TUI
    # epy                               # ebook reader
    # gtt                               # google translate TUI
    # smassh                            # typing test in the terminal
    # toipe                             # typing test in the terminal
    # ttyper                            # cli typing test
    # programmer-calculator

    ## Monitoring / fetch
    # htop
    btop-cuda
    nitch # systhem fetch util
    onefetch # fetch utility for git repo
    wavemon # monitoring for wireless network devices

    ## Fun / screensaver
    # asciiquarium-transparent
    # cbonsai
    # cmatrix
    # countryfetch
    # cowsay
    # figlet
    # fortune
    # lavat
    # lolcat
    # pipes
    # sl
    # tty-clock

    ## Multimedia
    # ani-cli
    imv
    # lowfi

    ## Utilities
    entr # perform action when file change
    ffmpeg-full
    file # Show file information
    jq # JSON processor
    killall
    libnotify
    openssl
    pamixer # pulseaudio command line mixer
    playerctl # controller for media players
    poweralertd
    unzip
    wget
  ];
}
