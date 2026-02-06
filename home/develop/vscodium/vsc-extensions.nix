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
in
{
  programs.vscode.profiles.default = {
    extensions = with pkgs.vscode-extensions; [
      ## Languages
      jnoortheen.nix-ide
      arrterian.nix-env-selector
      tamasfe.even-better-toml
      skellock.just

      ## Color scheme
      jonathanharty.gruvbox-material-icon-theme
    ];
  };
}
