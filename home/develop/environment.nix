{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ## IDEs
    jetbrains-toolbox

    ## LSP
    nixd # nix

    ## Formating
    shfmt
    treefmt
    nixfmt-rfc-style
  ];
}
