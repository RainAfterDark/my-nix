{ inputs, pkgs, ... }:
{
  home.packages = with pkgs; [
    linux-wallpaperengine
    inputs.linux-wallpaper-engine.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
