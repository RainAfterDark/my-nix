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
    android-studio

    ## Env
    devenv
    flox
    chrome

    ## Lang
    flutter332 # FIXME: 3.35 is broken on Android
    nixd # Nix LSP

    ## Python
    python313
    python313Packages.weasyprint

    ## Database
    pgcli
    pgmodeler

    ## Game Dev
    godot
    godot-mono
    godot-export-templates-bin
    aseprite

    ## Formating
    shfmt
    treefmt
    nixfmt-rfc-style
  ];

  home.sessionVariables = {
    CHROME_EXECUTABLE = lib.getExe chrome;
  };
}
