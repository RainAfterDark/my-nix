{
  lib,
  config,
  host,
  ...
}:
{
  ## IMPORTANT NOTE! Only import niri.homeModule
  ## when using home-manager as a standalone
  # imports = [ inputs.niri.homeModules.config ];

  programs.niri.settings = {
    outputs = {
      "Acer Technologies KA252Q G0 24280AC703W01" = {
        mode = {
          width = 1920;
          height = 1080;
          refresh = 120.0;
        };
      };
    };

    input = {
      warp-mouse-to-focus.enable = true;
      focus-follows-mouse = {
        enable = true;
        max-scroll-amount = "50%";
      };

      # Make caps lock an additional Mod key
      keyboard.xkb.options = "caps:super";
    };

    binds =
      with config.lib.niri.actions;
      let
        sh = spawn "sh" "-c";
      in
      {
        "Mod+T".action = spawn "kitty";
        "Mod+G".action = spawn "nemo";
        "Mod+F".action = spawn "walker";
        "Mod+V".action = sh "walker -m clipboard";
        "Mod+R".action = sh "swaync-client -t";
        "Mod+Shift+R".action = sh "swaync-client -C";

        "Alt+F4".action = close-window;
        "Alt+Tab".action = focus-window-down-or-column-right;
        "Alt+Shift+Tab".action = focus-window-up-or-column-left;

        "Mod+Z".action = close-window;
        "Mod+X".action = switch-preset-column-width;
        "Mod+C".action = switch-preset-window-height;
        "Mod+Tab".action = fullscreen-window;
        "Mod+Space".action = toggle-overview;

        "Mod+W".action = focus-window-or-workspace-up;
        "Mod+S".action = focus-window-or-workspace-down;
        "Mod+A".action = focus-column-or-monitor-left;
        "Mod+D".action = focus-column-or-monitor-right;
        "Mod+Q".action = consume-or-expel-window-left;
        "Mod+E".action = consume-or-expel-window-right;

        "Mod+Alt+W".action = move-window-up-or-to-workspace-up;
        "Mod+Alt+S".action = move-window-down-or-to-workspace-down;
        "Mod+Alt+A".action = swap-window-left;
        "Mod+Alt+D".action = swap-window-right;
        "Mod+Alt+Q".action = consume-window-into-column;
        "Mod+Alt+E".action = expel-window-from-column;

        "Print".action = screenshot { show-pointer = true; };
        "Alt+Print".action = screenshot-window { write-to-disk = true; };
      }
      // lib.optionalAttrs (host == "xps7590") {
        "Mod+B".action = sh "bzmenu -l walker";
        "Mod+N".action = spawn "networkmanager_dmenu";
      };

    window-rules = [
      { draw-border-with-background = false; }
      {
        matches = [
          { app-id = "org.pulseaudio.pavucontrol"; }
        ];
        open-floating = true;
      }
    ];

    layout = {
      preset-column-widths = [
        { proportion = 0.5; }
        { proportion = 0.75; }
        { proportion = 1.0; }
        { proportion = 0.25; }
      ];
      default-column-width = {
        proportion = 0.25;
      };

      gaps = 16;
      struts = {
        left = 14;
        right = 14;
        top = 0;
        bottom = 0;
      };

      always-center-single-column = true;
      center-focused-column = "never";
      background-color = "transparent";
      shadow.enable = true;

      focus-ring = {
        enable = true;
        width = 4;
        active.color = config.lib.stylix.colors.base07;
      };
    };

    workspaces = {
      a = { };
      b = { };
      c = { };
      d = { };
    };

    overview = {
      workspace-shadow.enable = false;
    };

    spawn-at-startup = [
      { command = [ "xwayland-satellite" ]; }
    ];

    prefer-no-csd = true;
    hotkey-overlay.skip-at-startup = true;
  };

  home.sessionVariables = {
    CLUTTER_BACKEND = "wayland";
    GDK_BACKEND = "wayland,x11";
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    ELECTRON_ENABLE_HARDWARE_ACCELERATION = "1";

    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "niri";
    DISPLAY = ":0";
  };
}
