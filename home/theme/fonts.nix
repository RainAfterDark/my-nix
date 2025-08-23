{ pkgs, ... }:
let
  mainFont = {
    package = pkgs.maple-mono.Normal-NF-CN;
    name = "Maple Mono Normal NF CN";
  };
in
{
  stylix.fonts = {
    monospace = mainFont;
    serif = mainFont;
    sansSerif = mainFont;
    sizes = {
      applications = 11;
      terminal = 11;
      desktop = 11;
      popups = 11;
    };
  };

  home.packages = with pkgs; [
    ## Packaged fonts
    # Nerd Fonts
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.caskaydia-cove
    nerd-fonts.hurmit
    nerd-fonts.symbols-only
    # MS Fonts
    corefonts
    vista-fonts

    # Emojis
    twemoji-color-font
    noto-fonts-emoji

    # Mono
    mainFont.package
    fantasque-sans-mono

    # CJK
    mplus-outline-fonts.githubRelease
    wqy_zenhei

    # Custom fonts
    stray-font
  ];

  fonts.fontconfig.enable = true;
}
