{
  lib,
  pkgs,
  config,
  host,
  colors,
  ...
}:
let
  environment = {
    CLUTTER_BACKEND = "wayland";
    # xdg-portal-gnome will NOT work if this is set
    # GDK_BACKEND = "wayland,x11";
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    ELECTRON_ENABLE_HARDWARE_ACCELERATION = "1";

    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "niri";
    # DISPLAY = ":0"; # Niri sets this for us, don't override
  };
in
{
  home.sessionVariables = environment;
  programs.niri.settings = {
    inherit environment;

    outputs = {
      "Acer Technologies KA252Q G0 24280AC703W01" = {
        mode = {
          width = 1920;
          height = 1080;
          # weird bug when plugged desktop vs laptop
          refresh = if (host == "desktop") then 119.997 else 120.0;
        };
      };
    };

    input = {
      warp-mouse-to-focus.enable = true;
      focus-follows-mouse = {
        enable = true;
        max-scroll-amount = "0%";
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
        # Apps/Widgets
        "Mod+T".action = spawn "kitty";
        "Mod+G".action = spawn "nemo";
        "Mod+F".action = spawn "walker";
        "Mod+V".action = sh "walker -m clipboard";
        "Mod+B".action = sh "walker --modules emojis,symbols";
        "Mod+R".action = sh "swaync-client -t";
        "Mod+Shift+R".action = sh "swaync-client -C";
        "Mod+O".action = spawn "wallpaper-selector";
        "Mod+P".action = sh "toggle-app pavucontrol";

        # Resizing
        "Mod+Z".action = close-window;
        "Mod+X".action = switch-preset-column-width;
        "Mod+C".action = switch-preset-window-height;

        # Fullscreen/Dynamic Cast
        "Mod+Tab".action = fullscreen-window;
        "Mod+Shift+Tab".action = toggle-windowed-fullscreen;
        "Mod+F8".action = set-dynamic-cast-window;
        "Mod+Alt+F8".action = clear-dynamic-cast-target;

        # Navigation
        "Mod+Space".action = toggle-overview;
        "Mod+W".action = focus-window-or-workspace-up;
        "Mod+S".action = focus-window-or-workspace-down;
        "Mod+A".action = focus-column-or-monitor-left;
        "Mod+D".action = focus-column-or-monitor-right;
        "Mod+Q".action = consume-or-expel-window-left;
        "Mod+E".action = consume-or-expel-window-right;

        # Movement
        "Mod+Alt+W".action = move-window-up-or-to-workspace-up;
        "Mod+Alt+S".action = move-window-down-or-to-workspace-down;
        "Mod+Alt+A".action = swap-window-left;
        "Mod+Alt+D".action = swap-window-right;
        "Mod+Alt+Q".action = consume-window-into-column;
        "Mod+Alt+E".action = expel-window-from-column;

        # PrntScrn
        "Print".action = screenshot { show-pointer = true; };
        "Alt+Print".action = screenshot-window { write-to-disk = true; };

        # "Windows" Keybinds
        "Alt+F4".action = close-window;
        "Alt+Tab".action = focus-window-down-or-column-right;
        "Alt+Shift+Tab".action = focus-window-up-or-column-left;
      }
      // lib.optionalAttrs (host == "xps7590") {
        "Mod+M".action = sh "bzmenu -l walker";
        "Mod+N".action = spawn "networkmanager_dmenu";
        "Mod+Shift+F8".action = set-dynamic-cast-monitor "eDP-1";
      };

    window-rules = [
      { draw-border-with-background = false; }
      {
        matches = [
          { app-id = "org.pulseaudio.pavucontrol"; }
        ];
        open-floating = true;
        default-floating-position = {
          relative-to = "top-right";
          x = 316;
          y = 8;
        };
        min-width = 800;
        min-height = 600;
      }
      {
        matches = [ { is-window-cast-target = true; } ];
        focus-ring = {
          enable = true;
          active.color = colors.base0E;
          inactive.color = colors.base0E-rgba 0.75;
        };
        shadow = {
          enable = true;
          color = colors.base0E-rgba 0.75;
          spread = 4;
          softness = 0;
          offset = {
            x = 0;
            y = 0;
          };
        };
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
        active.color = colors.base07;
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

    xwayland-satellite = {
      enable = true;
      path = lib.getExe pkgs.xwayland-satellite-unstable;
    };

    prefer-no-csd = true;
    hotkey-overlay.skip-at-startup = true;
  };
}
