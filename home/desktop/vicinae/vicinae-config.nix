{
  inputs,
  config,
  pkgs,
  ...
}:
let
  vicinae-module = inputs.vicinae.homeManagerModules.default;
in
{
  imports = [ vicinae-module ];
  stylix.targets.vicinae.enable = true;

  programs.vicinae = {
    enable = true;
    # use nixpkgs version for now as the flake seems to be broken
    # https://github.com/vicinaehq/vicinae/issues/2040
    package = pkgs.vicinae;

    settings = {
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
