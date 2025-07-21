{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ## LSP
    nixd # nix

    ## Formating
    shfmt
    treefmt
    nixfmt-rfc-style
  ];
}
