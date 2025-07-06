{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ## lsp
    nixd # nix

    ## formating
    shfmt
    treefmt
    nixfmt-rfc-style
  ];
}
