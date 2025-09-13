{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ## IDEs
    jetbrains-toolbox
    android-studio

    ## Env/Lang
    devenv
    flutter332 # FIXME: 3.35 is broken on Android
    nixd # nix LSP

    ## Formating
    shfmt
    treefmt
    nixfmt-rfc-style
  ];
}
