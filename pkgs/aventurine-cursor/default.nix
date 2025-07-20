{ stdenvNoCC, lib, ... }:
stdenvNoCC.mkDerivation {
  pname = "aventurine-cursor";
  version = "1.0";

  src = ./Aventurine.tar.gz;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/icons/Aventurine
    cp -r * $out/share/icons/Aventurine/
  '';

  meta = with lib; {
    description = "Aventurine Cursor Theme";
    platforms = platforms.all;
  };
}
