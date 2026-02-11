{ pkgs, host, ... }:
{
  stylix.targets.btop.enable = true;

  programs.btop = {
    enable = true;
    package = if (host == "t14-gen1") then pkgs.btop-rocm else pkgs.btop-cuda;
    settings = {
      update_ms = 500;
      rounded_corners = false;
    };
  };
}
