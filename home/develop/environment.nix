{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ## IDEs
    jetbrains-toolbox
    android-studio

    ## Lang
    flutter
    nixd # nix LSP

    ## Formating
    shfmt
    treefmt
    nixfmt-rfc-style
  ];
}
