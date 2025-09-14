{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  flox = inputs.flox.packages.${pkgs.system}.default;
  chrome = pkgs.ungoogled-chromium;
in
{
  home.packages = with pkgs; [
    ## IDEs
    jetbrains-toolbox
    android-studio

    ## Env
    devenv
    flox
    chrome

    ## Lang
    flutter332 # FIXME: 3.35 is broken on Android
    nixd # Nix LSP

    ## Formating
    shfmt
    treefmt
    nixfmt-rfc-style
  ];

  home.sessionVariables = {
    CHROME_EXECUTABLE = lib.getExe chrome;
  };
}
