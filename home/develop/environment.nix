{ inputs, pkgs, ... }:
{
  home.packages = with pkgs; [
    ## IDEs
    jetbrains-toolbox
    android-studio

    ## Env
    devenv
    inputs.flox.packages.${pkgs.system}.default

    ## Lang
    flutter332 # FIXME: 3.35 is broken on Android
    nixd # Nix LSP

    ## Formating
    shfmt
    treefmt
    nixfmt-rfc-style
  ];
}
