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
      ## Packaged fonts
      # Nerd Fonts
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      nerd-fonts.caskaydia-cove
      nerd-fonts.hurmit
      nerd-fonts.symbols-only

      # Emojis
      twemoji-color-font
      noto-fonts-emoji

      # Mono
      fantasque-sans-mono
      maple-mono.truetype-autohint

      # CJK
      mplus-outline-fonts.githubRelease
      wqy_zenhei

      # Custom fonts
      (mkCustomFont "stray")
    ];

  fonts.fontconfig.enable = true;
}
