{ ... }: {
  programs.vscodium.profiles.default = {
    userSettings = {
      "update.mode" = "none";
      # This stuff fixes vscode freaking out when theres an update
      "extensions.autoUpdate" = "off";
      # needed otherwise vscode crashes, see https://github.com/NixOS/nixpkgs/issues/246509
      "window.titleBarStyle" = "custom";
      "window.menuBarVisibility" = "toggle";
      "material-icon-theme.folders.theme" = "classic";
      "explorer.confirmDragAndDrop" = false;
      "terminal.integrated.smoothScrolling" = true;
      "files.autoSave" = "off";

      "editor.fontLigatures" = true;
      "editor.formatOnSave" = true;
      "editor.formatOnType" = true;
      "editor.formatOnPaste" = true;
      "editor.mouseWheelZoom" = true;
      "editor.smoothScrolling" = true;
      "editor.renderControlCharacters" = false;

      "workbench.iconTheme" = "gruvbox-material-icon-theme";
      "workbench.startupEditor" = "none";
      "workbench.layoutControl.type" = "menu";
      "workbench.editor.limit.enabled" = true;
      "workbench.editor.limit.value" = 10;
      "workbench.editor.limit.perEditorGroup" = true;
      "workbench.editor.showTabs" = "multiple";
      "workbench.secondarySideBar.defaultVisibility" = "hidden";
      "workbench.list.smoothScrolling" = true;
      "workbench.statusBar.visible" = false;
      "workbench.layoutControl.enabled" = false;

      # Fuck this shit
      "chat.disableAIFeatures" = true;
    };
  };
}
