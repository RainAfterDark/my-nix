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
    ## Lang
    nixd # Nix LSP

    ## IDEs
    # TODO: wait for fix https://nixpk.gs/pr-tracker.html?pr=571448
    # jetbrains-toolbox

    ## Env
    just
    flox
    chrome

    ## Create
    godot
    godot-export-templates-bin
    blender
    pixelorama
    gimp-with-plugins
    krita

    # LLM
    lmstudio

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
