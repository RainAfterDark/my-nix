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

  programs.google-chrome = {
    enable = true;
    package = chrome;
    commandLineArgs = [
      "--enable-logging=stderr"
      # WebGPU requirements
      "--ignore-gpu-blocklist"
      "--ozone-platform=x11"
      "--use-vulkan"
      "--enable-features=Vulkan,VulkanFromANGLE,DefaultANGLEVulkan"
    ];
  };

  home.sessionVariables = {
    CHROME_EXECUTABLE = lib.getExe chrome;
  };
}
