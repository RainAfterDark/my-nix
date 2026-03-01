{ inputs, config, ... }:
let
  vicinae-module = inputs.vicinae.homeManagerModules.default;
in
{
  imports = [ vicinae-module ];

  services.vicinae = {
    enable = true;

    settings = {
      font = {
        normal = {
          size = 12;
          family = config.stylix.fonts.monospace.name;
        };
      };

      launcher_window = {
        opacity = config.stylix.opacity.popups;
        layer_shell = {
          enabled = true;
          layer = "overlay";
        };
        client_side_decorations = {
          enabled = true;
          rounding = 0;
          border-width = 4;
        };
      };

      theme = {
        light = {
          name = "vicinae-light";
          icon_theme = "default";
        };
        dark = {
          name = "kanagawa";
          icon_theme = "default";
        };
      };

      pop_to_root_on_close = true;
      consider_preedit = true;
      favorites = [ ];
    };

    systemd = {
      enable = true;
      autoStart = true;
      environment = {
        EMOJI_FONT = ''"Noto Color Emoji"'';
      };
    };
  };
}
