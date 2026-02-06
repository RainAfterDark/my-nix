{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  flox = inputs.flox.packages.${pkgs.stdenv.hostPlatform.system}.default;
  chrome = pkgs.google-chrome;
in
{
  home.packages = with pkgs; [
    ## IDEs
    jetbrains-toolbox

    ## Env
    devenv
    flox
    just
    chrome

    ## Lang
    nixd # Nix LSP

    ## Game Dev
    godot
    godot-mono
    godot-export-templates-bin
    pixelorama

    ## Formating
    treefmt
    shfmt
    nixfmt
    taplo
  ];

  home.sessionVariables = {
    CHROME_EXECUTABLE = lib.getExe chrome;
  };
}
