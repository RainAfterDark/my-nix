{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wayland,
  libxkbcommon,
  ...
}:
rustPlatform.buildRustPackage {
  pname = "niri-zoom";
  version = "unstable-git";

  src = fetchFromGitHub {
    owner = "Ahmedhossamdev";
    repo = "niri-zoom";
    rev = "master";
    hash = "sha256-3n6xsFFX96KnpNym8DdgnfPGXEi30F77KJCMlBON3ms=";
  };
  cargoHash = "sha256-ISKNipvoRpaZ9mx6J9XUialXwuTrpRlNb+0Y5DaNIxY=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    wayland
    libxkbcommon
  ];

  meta = {
    description = "External Ctrl+scroll magnifier/zoom tool for niri (Wayland)";
    homepage = "https://github.com/Ahmedhossamdev/niri-zoom";
    license = lib.licenses.mit;
    mainProgram = "niri-zoomd";
    platforms = lib.platforms.linux;
  };
}
