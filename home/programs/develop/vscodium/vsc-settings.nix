{
  lib,
  host,
  flakeRoot,
  ...
}:
{
  stylix.targets.vscode.enable = true;

  programs.vscode.profiles.default = {
    userSettings = {
      "update.mode" = "none";
      "extensions.autoUpdate" = false; # This stuff fixes vscode freaking out when theres an update
      "window.titleBarStyle" = "custom"; # needed otherwise vscode crashes, see https://github.com/NixOS/nixpkgs/issues/246509

      "window.menuBarVisibility" = "toggle";
      "editor.fontSize" = lib.mkForce 13;
      "workbench.iconTheme" = "gruvbox-material-icon-theme";
      "material-icon-theme.folders.theme" = "classic";
      "vsicons.dontShowNewVersionMessage" = true;
      "explorer.confirmDragAndDrop" = false;
      "editor.fontLigatures" = true;
      "workbench.startupEditor" = "none";

      "editor.formatOnSave" = true;
      "editor.formatOnType" = true;
      "editor.formatOnPaste" = true;

      "workbench.layoutControl.type" = "menu";
      "workbench.editor.limit.enabled" = true;
      "workbench.editor.limit.value" = 10;
      "workbench.editor.limit.perEditorGroup" = true;
      "workbench.editor.showTabs" = "multiple";
      "files.autoSave" = "onWindowChange";
      "editor.renderControlCharacters" = false;
      "workbench.statusBar.visible" = false;
      "workbench.layoutControl.enabled" = false;

      "editor.mouseWheelZoom" = true;
      "editor.smoothScrolling" = true;
      "workbench.list.smoothScrolling" = true;
      "terminal.integrated.smoothScrolling" = true;

      # Nix
      "nix.serverPath" = "nixd";
      "nix.enableLanguageServer" = true;
      "nix.serverSettings" = {
        "nixd" =
          let
            flake = "(builtins.getFlake \"${flakeRoot}\")";
            nixosOptions = "${flake}.nixosConfigurations.${host}.options";
          in
          {
            "nixpkgs" = {
              "expr" = "${flake}.inputs.nixpkgs { }";
            };
            "formatting" = {
              "command" = [ "nixfmt" ];
            };
            "options" = {
              "nixos" = {
                "expr" = nixosOptions;
              };
              "home-manager" = {
                "expr" = "${nixosOptions}.home-manager.users.type.getSubOptions []";
              };
            };
          };
      };
    };
  };
}
