{ pkgs, ... }:
{
  home.packages =
    with pkgs;
    let
      mkCustomFont =
        font:
        (pkgs.stdenv.mkDerivation {
          name = "${font}-custom-font";
          src = ./${font};
          dontUnpack = true;
          installPhase = ''
            echo "src is: $src"
            ls -l $src
            mkdir -p $out/share/fonts
            cp $src/*.ttf $out/share/fonts
          '';
        });
    in
    [
      # Packaged fonts
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      nerd-fonts.caskaydia-cove
      nerd-fonts.symbols-only
      twemoji-color-font
      noto-fonts-emoji
      fantasque-sans-mono
      maple-mono.truetype-autohint

      # Custom fonts
      (mkCustomFont "stray")
    ];

  fonts.fontconfig.enable = true;
}
