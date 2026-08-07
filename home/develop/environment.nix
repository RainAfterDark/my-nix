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
    jetbrains-toolbox

    ## Env
    just
    flox
    chrome

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
