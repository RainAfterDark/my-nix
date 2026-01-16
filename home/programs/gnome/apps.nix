{ pkgs, ... }:
{
  home.packages = (
    with pkgs;
    [
      dconf-editor
      gnome-disk-utility
      gnome-power-manager
      evince # pdf
      file-roller # archive
      gnome-text-editor # gedit
      gnome-calculator
      nautilus
    ]
  );
}
