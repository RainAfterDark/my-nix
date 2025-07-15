{ inputs, ... }:
let
  customTheme = ''
    :root {
      --bg-4: #282828BB;
    }
    body {
      --font: 'Maple Mono';
      --code-font: 'Maple Mono';
    }
  '';
in
{
  imports = [ inputs.nixcord.homeModules.nixcord ];
  programs.nixcord = {
    enable = true;
    discord.enable = false;
    vesktop.enable = true;
    quickCss = customTheme;
    config = {
      frameless = true;
      transparent = true;
      useQuickCss = true;
      themeLinks = [
        "https://raw.githubusercontent.com/refact0r/system24/refs/heads/main/theme/flavors/system24-vencord.theme.css"
      ];
    };
  };

  programs.niri.settings = {
    spawn-at-startup = [
      { command = [ "vesktop" ]; }
    ];
    window-rules = [
      {
        matches = [ { app-id = "vesktop"; } ];
        open-maximized = true;
        open-on-workspace = "a";
      }
    ];
  };
}
