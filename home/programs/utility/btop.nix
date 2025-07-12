{ pkgs, ... }:
{
  programs.btop = {
    enable = true;
    package = pkgs.btop-cuda;
    settings = {
      color_theme = "TTY";
      theme_background = false;
      update_ms = 500;
      rounded_corners = false;
    };
  };
}
