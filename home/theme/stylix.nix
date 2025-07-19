{ pkgs, ... }:
let
  cursor = {
    name = "Aventurine";
    package = pkgs.aventurine-cursor;
    size = 24;
  };
in
{
  stylix = {
    inherit cursor;

    targets = {
      gnome.enable = true;
      gtk.enable = true;
      qt.enable = true;
    };

    iconTheme = {
      enable = true;
      dark = "Papirus-Dark";
      package = pkgs.papirus-icon-theme.override { color = "black"; };
    };
  };

  programs.niri.settings = {
    cursor = {
      theme = cursor.name;
      inherit (cursor) size;
    };
  };
}
