{ stdenv, lib, ... }:
stdenv.mkDerivation {
  pname = "aventurine-cursor";
  version = "1.0";
  src = ./Aventurine.tar.gz;

  installPhase = ''
    mkdir -p $out/share/icons/Aventurine
    tar -xzf $src -C $out/share/icons/Aventurine --strip-components=1
  '';

  meta = with lib; {
    description = "Aventurine Cursor Theme";
    platforms = platforms.all;
  };
}
