{
  inputs,
  config,
  colors,
  ...
}:
let
  fontName = config.stylix.fonts.monospace.name;
  customTheme = with colors; ''
    :root {
      --bg-1: ${base01};
      --bg-2: ${base02};
      --bg-3: ${base03};
      --bg-4: ${base00-rgba 0.75};

      --text-1: ${base07};
      --text-2: ${base07};
      --text-3: ${base06};
      --text-4: ${base05};
      --text-5: ${base05}66;
    }
    body {
      --font: '${fontName}';
      --code-font: '${fontName}';
      --transparency-tweaks: on;
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
