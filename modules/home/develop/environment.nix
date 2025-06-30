{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ## lsp
    nixd # nix
    qt6.full # qt

    ## formating
    shfmt
    treefmt
    nixfmt-rfc-style
  ];
}
