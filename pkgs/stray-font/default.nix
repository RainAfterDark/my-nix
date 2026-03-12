{ lib, stdenvNoCC, ... }:
stdenvNoCC.mkDerivation {
  pname = "stray-font";
  version = "1.0";

  src = ./stray;
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "sha256-ewUWfQhR5PrdtS8uH+KGmC7DRnTGVLU8/JZK4sIh3HM=";

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    # bash
    mkdir -p $out/share/fonts
    cp $src/*.ttf $out/share/fonts
  '';

  meta = with lib; {
    description = "Stray Font";
    license = licenses.cc-by-nd-30;
    platforms = platforms.all;
  };
}
