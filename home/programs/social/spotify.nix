{
  inputs,
  pkgs,
  config,
  ...
}:
{
  imports = [ inputs.spicetify-nix.homeManagerModules.spicetify ];

  programs.spicetify =
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
    in
    {
      enable = true;
      enabledExtensions = with spicePkgs.extensions; [
        shuffle
        loopyLoop
        keyboardShortcut

        history
        songStats
        betterGenres
        copyToClipboard
        volumePercentage
        sectionMarker
      ];

      theme = spicePkgs.themes.text // {
        additionalCss = ''
          :root {
            --font-family: "${config.stylix.fonts.monospace.name}", monospace;
            --border-width: 2px;
          }
        '';
      };

      colorScheme = "custom";
      customColorScheme = with config.lib.stylix.colors; {
        accent = base0B;
        accent-active = base0D;
        accent-inactive = base02;
        banner = base0D;
        border-active = base0E;
        border-inactive = base02;
        header = base06;
        highlight = base06;
        main = base00;
        notification = base0A;
        notification-error = base08;
        subtext = base05;
        text = base07;
      };
      wayland = false; # wayland breaks dropdowns somehow
    };

  programs.niri.settings = {
    spawn-at-startup = [
      { command = [ "spotify" ]; }
    ];
    window-rules = [
      {
        matches = [ { app-id = "Spotify"; } ];
        open-maximized = true;
        open-on-workspace = "a";
        opacity = 0.9;
      }
    ];
  };
}
