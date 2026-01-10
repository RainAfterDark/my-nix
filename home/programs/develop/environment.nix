{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  flox = inputs.flox.packages.${pkgs.stdenv.hostPlatform.system}.default;
  chrome = pkgs.ungoogled-chromium;
in
{
  home.packages = with pkgs; [
    ## IDEs
    jetbrains-toolbox

    ## Env
    devenv
    flox
    chrome

    ## Lang
    nixd # Nix LSP

    ## Game Dev
    godot
    godot-mono
    godot-export-templates-bin
    pixelorama

    ## Formating
    shfmt
    treefmt
    nixfmt
  ];

  home.sessionVariables = {
    CHROME_EXECUTABLE = lib.getExe chrome;
  };
}
