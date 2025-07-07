{
  config,
  inputs,
  ...
}:
{
  imports = [ inputs.niri.homeModules.config ];
  programs.niri.settings = {
    spawn-at-startup = [
      { command = [ "xwayland-satellite" ]; }
    ];

    outputs = {
      "Acer Technologies KA252Q G0 24280AC703W01" = {
        mode = {
          width = 1920;
          height = 1080;
          refresh = 119.997;
        };
      };
    };

    layer-rules = [
      {
        matches = [ { namespace = "mpvpaper"; } ];
        place-within-backdrop = true;
      }
    ];

    layout = {
      preset-column-widths = [
        { proportion = 2.0 / 3.0; }
        { proportion = 1.0; }
        { proportion = 1.0 / 3.0; }
        { proportion = 0.9 / 2.0; }
      ];
      default-column-width = {
        proportion = 0.9 / 2.0;
      };

      gaps = 12;
      struts = {
        left = 24;
        right = 24;
        top = 0;
        bottom = 12;
      };

      always-center-single-column = true;
      center-focused-column = "never";
      background-color = "transparent";
      shadow.enable = true;

      focus-ring = {
        enable = true;
        width = 3;
        active.color = "white";
      };
    };

    overview = {
      workspace-shadow.enable = false;
    };

    input = {
      # Moves mouse to the focused window
      warp-mouse-to-focus.enable = true;

      # Mouse can change window focus
      focus-follows-mouse = {
        enable = true;
        max-scroll-amount = "100%";
      };

      # Make caps lock an additional Mod key
      keyboard.xkb.options = "caps:super";
    };

    binds = with config.lib.niri.actions; {
      "Mod+T".action = spawn "kitty";
      "Mod+B".action = spawn "zen-beta";
      "Mod+G".action = spawn "nemo";

      "Mod+Z".action = close-window;
      "Alt+F4".action = close-window;
      "Alt+Tab".action = focus-window-down-or-column-right;
      "Alt+Shift+Tab".action = focus-window-up-or-column-left;
      "Mod+F".action = fullscreen-window;
      "Mod+X".action = switch-preset-column-width;
      "Mod+C".action = switch-preset-window-height;

      "Mod+W".action = focus-window-or-workspace-up;
      "Mod+S".action = focus-window-or-workspace-down;
      "Mod+A".action = focus-column-or-monitor-left;
      "Mod+D".action = focus-column-or-monitor-right;
      "Mod+Q".action = consume-or-expel-window-left;
      "Mod+E".action = consume-or-expel-window-right;
      "Mod+Space".action = toggle-overview;

      "Mod+Alt+W".action = move-window-up-or-to-workspace-up;
      "Mod+Alt+S".action = move-window-down-or-to-workspace-down;
      "Mod+Alt+A".action = swap-window-left;
      "Mod+Alt+D".action = swap-window-right;
      "Mod+Alt+Q".action = consume-window-into-column;
      "Mod+Alt+E".action = expel-window-from-column;
    };

    workspaces = {
      a = { };
      b = { };
      c = { };
      d = { };
    };

    window-rules = [
      {
        draw-border-with-background = false;
      }
    ];

    prefer-no-csd = true;
    hotkey-overlay.skip-at-startup = true;
  };
}
