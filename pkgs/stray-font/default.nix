{ stdenvNoCC, lib, ... }:
stdenvNoCC.mkDerivation {
  pname = "stray-font";
  version = "1.0";

  src = ./stray;
  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/fonts
    cp $src/*.ttf $out/share/fonts
  '';

  meta = with lib; {
    description = "Stray Font";
    license = licenses.cc-by-nd-30;
    platforms = platforms.all;
  };
}
