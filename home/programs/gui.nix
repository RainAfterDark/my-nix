{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ## Multimedia
    # audacity
    # gimp
    obs-studio
    pavucontrol
    # soundwireserver
    # video-trimmer
    # vlc

    ## Utility
    libreoffice
    mission-center # GUI resources monitor
    # zenity

    ## Level editor
    # ldtk
    # tiled
  ];
}
