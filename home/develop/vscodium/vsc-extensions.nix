{ pkgs, ... }:
let
  jonathanharty.gruvbox-material-icon-theme =
    pkgs.vscode-utils.buildVscodeMarketplaceExtension
      {
        mktplcRef = {
          name = "gruvbox-material-icon-theme";
          publisher = "JonathanHarty";
          version = "1.1.5";
          hash = "sha256-86UWUuWKT6adx4hw4OJw3cSZxWZKLH4uLTO+Ssg75gY=";
        };
      };

  atomicspirit.nix-embedded-highlighter =
    pkgs.vscode-utils.buildVscodeMarketplaceExtension
      {
        mktplcRef = {
          name = "nix-embedded-highlighter";
          publisher = "atomicspirit";
          version = "0.0.1";
          hash = "sha256-KZfUaPjReHQH0XCCiejAs+0Go8WEeGiOuxjkTfSnku0=";
        };
      };
in
{
  programs.vscode.profiles.default = {
    extensions = with pkgs.vscode-extensions; [
      github.vscode-github-actions
      jnoortheen.nix-ide
      vadimcn.vscode-lldb
      danielgavin.ols
      skellock.just
      tamasfe.even-better-toml

      jonathanharty.gruvbox-material-icon-theme
      atomicspirit.nix-embedded-highlighter
    ];
  };
}
