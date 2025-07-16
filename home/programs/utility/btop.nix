{ pkgs, ... }:
{
  stylix.targets.btop.enable = true;
  programs.btop = {
    enable = true;
    package = pkgs.btop-cuda;
    settings = {
      update_ms = 500;
      rounded_corners = false;
    };
  };
}
