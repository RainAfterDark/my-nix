{ lib, ... }:
{
  programs.vscode.profiles.default = {
    userSettings = {
      update.mode = "none";
      # This stuff fixes vscode freaking out when theres an update
      extensions.autoUpdate = false;
      # needed otherwise vscode crashes, see https://github.com/NixOS/nixpkgs/issues/246509
      window.titleBarStyle = "custom";

      window.menuBarVisibility = "toggle";
      editor.fontSize = lib.mkForce 13;
      workbench.iconTheme = "gruvbox-material-icon-theme";
      material-icon-theme.folders.theme = "classic";
      vsicons.dontShowNewVersionMessage = true;
      explorer.confirmDragAndDrop = false;
      editor.fontLigatures = true;
      workbench.startupEditor = "none";

      editor.formatOnSave = true;
      editor.formatOnType = true;
      editor.formatOnPaste = true;

      workbench.layoutControl.type = "menu";
      workbench.editor.limit.enabled = true;
      workbench.editor.limit.value = 10;
      workbench.editor.limit.perEditorGroup = true;
      workbench.editor.showTabs = "multiple";
      workbench.secondarySideBar.defaultVisibility = "hidden";
      files.autoSave = "onWindowChange";
      editor.renderControlCharacters = false;
      workbench.statusBar.visible = false;
      workbench.layoutControl.enabled = false;

      editor.mouseWheelZoom = true;
      editor.smoothScrolling = true;
      workbench.list.smoothScrolling = true;
      terminal.integrated.smoothScrolling = true;

      # Fuck this shit
      chat.disableAIFeatures = true;
    };
  };
}
