{ inputs, config, ... }:
let
  vicinae-module = inputs.vicinae.homeManagerModules.default;
in
{
  imports = [ vicinae-module ];
  stylix.targets.vicinae.enable = true;

  programs.vicinae = {
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
          enabled = false;
          layer = "overlay";
        };
        client_side_decorations = {
          enabled = true;
          rounding = 0;
          border-width = 2;
        };
      };

      pop_to_root_on_close = true;
      consider_preedit = true;
      favorites = [ ];
    };

    systemd = {
      enable = true;
      autoStart = true;
    };
  };
}
