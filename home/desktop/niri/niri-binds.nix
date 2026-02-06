{ config, ... }:
{
  programs.niri.settings = with config.lib.niri.actions; {
    binds =
      let
        sh = spawn "sh" "-c";
        onlyOne = c: f: sh "flock -n /tmp/${c}.lock sh -c '${c} ${f}'";
        waypaperArgs = "--folder $FLAKE_ROOT/assets/gif --backend swww";
      in
      ## General Controls
      {
        # Apps/Widgets
        "Mod+T".action = spawn "kitty";
        "Mod+G".action = spawn "nemo";
        "Mod+F".action = spawn "walker";
        "Mod+V".action = sh "walker -m clipboard";
        "Mod+B".action = sh "walker -m symbols";
        "Mod+N".action = sh "walker -m unicode";
        "Mod+R".action = sh "swaync-client -t";
        "Mod+Shift+R".action = sh "swaync-client -C";
        "Mod+O".action = sh "toggle-app waypaper ${waypaperArgs}";
        "Mod+I".action = sh "toggle-app pavucontrol";
        "Mod+Escape".action = onlyOne "wlogout" "-s -b 4";

        # Resizing
        "Mod+Z".action = close-window;
        "Mod+X".action = switch-preset-column-width;
        "Mod+C".action = switch-preset-window-height;

        # Fullscreen/Dynamic Cast
        "Mod+L".action = fullscreen-window;
        "Mod+Shift+L".action = toggle-window-floating;
        "Mod+F8".action = set-dynamic-cast-window;
        "Mod+Alt+F8".action = clear-dynamic-cast-target;
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
        # FIXME when upstream issue is fixed:
        # https://github.com/sodiboo/niri-flake/issues/922#issuecomment-2729519779
        "Print".action.screenshot-screen = [ ];
        "Mod+P".action.screenshot-screen = [ ];
        "Ctrl+Print".action.screenshot = {
          show-pointer = true;
        };
        "Mod+Ctrl+P".action.screenshot = {
          show-pointer = true;
        };
        "Alt+Print".action.screenshot-window = {
          write-to-disk = true;
        };
        "Mod+Alt+P".action.screenshot-window = {
          write-to-disk = true;
        };
      }
      ## Volume and Brightness Controls
      // (
        let
          volumeStep = "10";
          brightnessStep = "10";

          mkControlAction = a: {
            action = spawn "sh" "-c" a;
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
          "Mod+Alt+TouchpadScrollDown" = brightnessUp;
          "Mod+Alt+TouchpadScrollUp" = brightnessDown;
          "Mod+Alt+WheelScrollUp" = brightnessUp;
          "Mod+Alt+WheelScrollDown" = brightnessDown;
        }
      );

    input = {
      warp-mouse-to-focus.enable = true;
      focus-follows-mouse = {
        enable = true;
        max-scroll-amount = "0%";
      };

      # Make caps lock an additional escape key
      # see man xkeyboard-config
      keyboard.xkb.options = "caps:escape";
    };
  };
}
