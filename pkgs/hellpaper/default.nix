{
  lib,
  stdenv,
  makeWrapper,
  raylib,
  inputs,
  ...
}:
stdenv.mkDerivation rec {
  pname = "hellpaper";
  src = inputs.hellpaper;
  version = "0-unstable-${src.shortRev}";

  buildInputs = [ raylib ];
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    # bash
    install -Dm755 hellpaper -t $out/bin
  '';

  meta = {
    homepage = "https://github.com/danihek/hellpaper";
    description = "A wallpaper picker for Linux, built with Raylib.";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "hellpaper";
  };
}
