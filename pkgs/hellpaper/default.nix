{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  raylib,
}:
stdenv.mkDerivation {
  pname = "hellpaper";
  version = "unstable-2025-09-24";

  src = fetchFromGitHub {
    owner = "danihek";
    repo = "hellpaper";
    rev = "d8af3ff83b567869c11ba31e39c3c10e4bee53e6";
    hash = "sha256-1vX1hC4RVNmmIn0j7giAqrzGV12zk2FMesUOX/iI1eY=";
  };

  buildInputs = [ raylib ];
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -Dm755 hellpaper -t $out/bin
  '';

  meta = {
    homepage = "https://github.com/danihek/hellpaper";
    description = "A wallpaper picker for Linux, built with Raylib.";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ danihek ];
    mainProgram = "hallpaper";
  };
}
