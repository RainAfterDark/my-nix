{ pkgs, ... }:
let
  cursor = {
    name = "Aventurine";
    package = pkgs.aventurine-cursor;
    size = 32;
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

    icons = {
      enable = true;
      light = "Vimix-white";
      dark = "Vimix-white-dark";
      package = pkgs.vimix-icon-theme;
    };

    opacity = {
      applications = 0.85;
      terminal = 0.85;
      popups = 0.7;
    };
  };

  programs.niri.settings = {
    cursor = {
      theme = cursor.name;
      inherit (cursor) size;
    };
  };
}
