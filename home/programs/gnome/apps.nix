{ pkgs, ... }:
{
  home.packages = (
    with pkgs;
    [
      dconf-editor
      gnome-disk-utility

      evince # pdf
      file-roller # archive
      gnome-text-editor # gedit
      gnome-calculator
    ]
  );
}
