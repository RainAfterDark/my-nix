{ inputs, pkgs, ... }:
let
  lwe = pkgs.linux-wallpaperengine.overrideAttrs (o: rec {
    src = inputs.linux-wallpaperengine;
    version = "0-unstable-${src.shortRev}";
    buildInputs = o.buildInputs ++ [ pkgs.quickjs-ng ];
  });

  system = pkgs.stdenv.hostPlatform.system;
  lweGuiPkg = inputs.linux-wallpaper-engine.packages.${system}.default;
  lweGui = lweGuiPkg.override { linux-wallpaperengine = lwe; };
in
{
  home.packages = [
    lwe
    lweGui
  ];
}
