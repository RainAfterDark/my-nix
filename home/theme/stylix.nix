{ pkgs, ... }:
{
  stylix = {
    targets = {
      gnome.enable = true;
      gtk.enable = true;
      qt.enable = true;
    };

    fonts = rec {
      monospace = {
        package = pkgs.maple-mono.truetype-autohint;
        name = "Maple Mono";
      };
      serif = monospace;
      sansSerif = monospace;
      sizes = {
        terminal = 11;
      };
    };

    cursor = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 24;
    };

    iconTheme = {
      enable = true;
      dark = "Papirus-Dark";
      package = pkgs.papirus-icon-theme.override { color = "black"; };
    };
  };
}
