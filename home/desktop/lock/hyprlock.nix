{ config, colors, ... }:
let
  fontFamily = config.stylix.fonts.monospace.name;
in
{
  stylix.targets.hyprlock = {
    enable = true;
    image.enable = false;
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = false;
        ignore_empty_input = true;
      };

      auth = {
        fingerprint = {
          enabled = true;
          retry_delay = 250;
        };
      };

      animations = {
        enabled = true;
        fade_in = {
          duration = 250;
          bezier = "easeOutQuint";
        };
        fade_out = {
          duration = 250;
          bezier = "easeOutQuint";
        };
      };

      background = {
        path = "screenshot";
        blur_passes = 2;
        blur_size = 4;
      };

      label = [
        {
          monitor = "";
          text = ''cmd[update:1000] echo -e "$(LC_TIME=ja_JP.UTF-8 date +%m月%d)"'';
          color = "rgb(${colors.base0D})";
          font_family = fontFamily;
          font_size = 47;
          position = "0, 80";
          shadow_passes = 2;
        }
        {
          monitor = "";
          text = ''cmd[update:1000] echo "<span>$(date +%H:%M:%S)</span>"'';
          color = "rgb(${colors.base0C}";
          font_family = fontFamily;
          font_size = 67;
          position = "0, 0";
          shadow_passes = 2;
        }
      ];

      input-field = {
        monitor = "";
        size = "220, 60";
        position = "0, -90";
        font_family = fontFamily;
        font_size = 67;
        placeholder_text = "󰦝 認証";
        fail_text = " 失敗";
        fade_on_empty = false;
        outline_thickness = 5;
        dots_rounding = 0;
        rounding = 0;
        shadow_passes = 2;
      };
    };
  };
}
