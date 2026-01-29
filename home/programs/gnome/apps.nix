{ pkgs, ... }:
{
  home.packages = (
    with pkgs;
    [
      dconf-editor # gnome config
      file-roller # archive
      evince # pdf
      nautilus # file explorer

      gnome-disk-utility # disks/partitions
      gnome-text-editor # gedit
      gnome-calculator # calc
    ]
  );
}
