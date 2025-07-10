{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    ## Multimedia
    # audacity
    # gimp
    pavucontrol

    ## Social
    inputs.zen-browser.packages."${system}".default
    vesktop

    ## Utility
    libreoffice
    mission-center # GUI resources monitor
    # zenity

    ## Level editor
    # ldtk
    # tiled
  ];
}
