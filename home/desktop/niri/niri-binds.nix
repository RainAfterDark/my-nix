{
  lib,
  config,
  host,
  ...
}:
{
  programs.niri.settings = with config.lib.niri.actions; {
    binds =
      let
        scArgs = {
          show-pointer = true;
        };
      in
      ## General Controls
      {
        # Apps/Widgets
        "Mod+T".action = spawn "kitty";
        "Mod+G".action = spawn "nemo";
        "Mod+F".action = spawn-sh "vicinae toggle";
        "Mod+V".action = spawn-sh "vicinae vicinae://launch/clipboard/history";
        "Mod+B".action = spawn-sh "vicinae vicinae://launch/core/search-emojis";
        "Mod+R".action =
          spawn-sh "noctalia msg panel-toggle control-center notifications";
        "Mod+Shift+R".action = spawn-sh "noctalia msg notification-clear-active";
        "Mod+O".action =
          spawn-sh "vicinae vicinae://launch/@sovereign/vicinae-extension-awww-switcher-0/wpgrid";
        "Mod+Shift+O".action =
          spawn-sh "vicinae vicinae://launch/@sovereign/vicinae-extension-awww-switcher-0/wprandom";
        "Mod+I".action = spawn-sh "noctalia-shell ipc call volume togglePanel";
        "Mod+Escape".action = spawn-sh "noctalia msg panel-toggle session";

        # Resizing
        "Mod+Z".action = close-window;
        "Mod+X".action = switch-preset-column-width;
        "Mod+C".action = switch-preset-window-height;

        # Fullscreen/Dynamic Cast
        "Mod+L".action = fullscreen-window;
        "Mod+K".action = toggle-window-floating;
        "Mod+F8".action = set-dynamic-cast-window;
        "Mod+Ctrl+F8".action = clear-dynamic-cast-target;
        "Mod+Shift+F8".action = set-dynamic-cast-monitor;

        # Navigation
        "Mod+Space".action = toggle-overview;
        "Mod+W".action = focus-window-or-workspace-up;
        "Mod+S".action = focus-window-or-workspace-down;
        "Mod+A".action = focus-column-or-monitor-left;
        "Mod+D".action = focus-column-or-monitor-right;
        "Mod+Q".action = consume-or-expel-window-left;
        "Mod+E".action = consume-or-expel-window-right;

        # Movement
        "Mod+Shift+W".action = move-window-up-or-to-workspace-up;
        "Mod+Shift+S".action = move-window-down-or-to-workspace-down;
        "Mod+Shift+A".action = swap-window-left;
        "Mod+Shift+D".action = swap-window-right;
        "Mod+Shift+Q".action = consume-window-into-column;
        "Mod+Shift+E".action = expel-window-from-column;

        # PrntScrn
        "Print".action.screenshot-screen = scArgs;
        "Mod+P".action.screenshot-screen = scArgs;
        "Ctrl+Print".action.screenshot = scArgs;
        "Mod+Ctrl+P".action.screenshot = scArgs;
        "Shift+Print".action.screenshot-window = scArgs;
        "Mod+Shift+P".action.screenshot-window = scArgs;
      }
      ## Volume and Brightness Controls
      // (
        let
          volumeStep = "2";
          brightnessStep = "5";

          mkControlAction = action: {
            action = spawn-sh action;
            allow-when-locked = true;
          };

          volume = v: mkControlAction "pamixer ${v}";
          volumeUp = volume "-i ${volumeStep}";
          volumeDown = volume "-d ${volumeStep}";

          brightness = v: mkControlAction "brightnessctl set ${v}";
          brightnessUp = brightness "+${brightnessStep}%";
          brightnessDown = brightness "${brightnessStep}%-";
        in
        {
          "XF86AudioRaiseVolume" = volumeUp;
          "XF86AudioLowerVolume" = volumeDown;
          "Mod+TouchpadScrollDown" = volumeUp;
          "Mod+TouchpadScrollUp" = volumeDown;
          "Mod+WheelScrollUp" = volumeUp;
          "Mod+WheelScrollDown" = volumeDown;

          "XF86MonBrightnessUp" = brightnessUp;
          "XF86MonBrightnessDown" = brightnessDown;
          "Mod+Shift+TouchpadScrollDown" = brightnessUp;
          "Mod+Shift+TouchpadScrollUp" = brightnessDown;
          "Mod+Shift+WheelScrollUp" = brightnessUp;
          "Mod+Shift+WheelScrollDown" = brightnessDown;
        }
      )
      ## Allow toggling internal display for laptops
      // lib.optionalAttrs (host != "desktop") (
        let
          eDP = state: "{ niri msg output eDP-1 ${state}; }";
          toggle-eDP = "niri msg outputs | grep -n2 eDP | grep -q Disabled && ${eDP "on"} || ${eDP "off"}";
        in
        {
          "Mod+M" = {
            action = spawn-sh toggle-eDP;
            allow-when-locked = true;
          };
        }
      );

    input = {
      warp-mouse-to-focus.enable = false;
      focus-follows-mouse = {
        enable = true;
        max-scroll-amount = "0%";
      };

      # Make caps lock an additional escape key
      # see man xkeyboard-config
      keyboard.xkb.options = "caps:escape";
    }

    # Enable touch on Thinkpad
    // lib.optionalAttrs (host == "t14-gen1") { touch.map-to-output = "eDP-1"; }

    # Enable touchpad on laptops
    // lib.optionalAttrs (host != "desktop") {
      touchpad = {
        tap = true;
        natural-scroll = true;
        tap-button-map = "left-right-middle";
      };
    };
  };
}
