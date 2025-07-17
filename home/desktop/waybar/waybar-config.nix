{ colors, ... }:
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings.mainBar = with colors; {
      ## Config
      reload_style_on_change = true;
      layer = "top";
      position = "top";
      spacing = 0;

      ## Layout
      modules-left = [
        "custom/nixos"
        "custom/border"
        "niri/workspaces"
        "custom/border"
        "wlr/taskbar"
        "custom/border"
      ];

      modules-center = [
        "custom/border2"
        "custom/date"
        "clock"
        "custom/day"
        "custom/border2"
      ];

      modules-right = [
        "custom/border"
        "custom/cpu"
        "custom/gpu"
        "memory"
        "custom/border"
        "custom/ping"
        "custom/pipewire"
        "battery"
        "custom/border"
        "custom/notification"
      ];

      ## Modules
      "custom/border" = {
        format = "<span></span>";
      };

      "custom/border2" = {
        format = "<span></span>";
      };

      "custom/dashes" = {
        format = "<span></span>";
      };

      "custom/nixos" = {
        format = "";
        tooltip = false;
      };

      "niri/workspaces" = {
        format = "{icon}";
        format-icons = {
          "5" = "e";
          "6" = "f";
          "7" = "g";
          "8" = "h";
          "9" = "i";
          "10" = "j";
        };
      };

      "wlr/taskbar" = {
        on-click = "activate";
        on-click-middle = "close";
        sort-by-app-id = true;
        format = "{app_id}";
        app_ids-mapping = {
          codium = "";
          imv = "";
          kitty = "";
          mpv = "";
          nemo = "󰷏";
          Spotify = "";
          vesktop = "";
          zen-beta = "";
          "com.obsproject.Studio" = "";
          "org.gnome.TextEditor" = "󱩼";
          "org.pulseaudio.pavucontrol" = "";
          "moe.launcher.the-honkers-railway-launcher" = "";
          "The Honkers Railway Launcher" = "";
          "starrail.exe" = "";
          unknown = "";
        };
      };

      "custom/date" = {
        interval = 1;
        exec = "LC_TIME=ja_JP.UTF-8 date +%m月%d";
      };

      clock = {
        interval = 1;
        locale = "ja_JP.utf8";
        format = "󰥔 {:%H:%M:%S}";
        tooltip-format = "<span font='M PLUS 1 Code'>{calendar}</span>";
        calendar = {
          mode = "month";
          mode-mon-col = 3;
          on-scroll = 1;
          format = {
            months = "<span color='${base0D}'><b>{}</b></span>";
            days = "<span color='${base07}'>{}</span>";
            weeks = "<span color='${base0B}'><b>W{}</b></span>";
            weekdays = "<span color='${base0C}'><b>{}</b></span>";
            today = "<span color='${base0E}'><b>{}</b></span>";
          };
        };
        actions = {
          on-click-middle = "shift_reset";
          on-scroll-up = "shift_up";
          on-scroll-down = "shift_down";
        };
      };

      "custom/day" = {
        interval = 1;
        exec = "LC_TIME=ja_JP.UTF-8 date +%A";
      };

      "custom/cpu" = {
        interval = 2;
        exec = "waybar-cpu";
        return-type = "json";
        format = ''<span fgcolor='${base00}' bgcolor='${base07}'>┇ </span> {percentage:0>2}%'';
      };

      "custom/gpu" = {
        interval = 2;
        exec = "waybar-gpu";
        return-type = "json";
        format = ''<span bgcolor='${base00}' fgcolor='${base07}'>┇󰮄 </span> {percentage:0>2}%'';
      };

      memory = {
        interval = 2;
        format = ''<span fgcolor='${base00}' bgcolor='${base07}'>┇ </span> {percentage:0>2}%'';
      };

      "custom/ping" = {
        interval = 2;
        exec = ''
          ping -c1 -w1 8.8.8.8 |
          awk -F"[= ]" '/time=/{print int($10); found=1} END{if (!found) print -1}'
        '';
        format = "󰖩 {:>2}ms";
        tooltip = false;
      };

      "custom/pipewire" = {
        tooltip = false;
        max-length = 6;
        exec = "waybar-pipewire";
        on-click = "pavucontrol";
      };

      battery = {
        interval = 2;
        states = {
          "100" = 100;
          "75" = 75;
          "50" = 50;
          "25" = 25;
          "10" = 10;
        };
        format = "~󰂑{capacity:0>2}%";
        format-charging-100 = "+󰁹{capacity:0>2}%";
        format-charging-75 = "+󰂀{capacity:0>2}%";
        format-charging-50 = "+󰁾{capacity:0>2}%";
        format-charging-25 = "+󰁼{capacity:0>2}%";
        format-charging-10 = "+󰁺{capacity:0>2}%";
        format-discharging-100 = "-󰁹{capacity:0>2}%";
        format-discharging-75 = "-󰂀{capacity:0>2}%";
        format-discharging-50 = "-󰁾{capacity:0>2}%";
        format-discharging-25 = "-󰁼{capacity:0>2}%";
        format-discharging-10 = "-󰁺{capacity:0>2}%";
        tooltip-format = "{time:<11} {power:>04.1f}W";
      };

      "custom/notification" = {
        tooltip = false;
        format = "{icon}";
        format-icons = {
          notification = "󱅫";
          none = "";
          dnd-notification = "󰵙";
          dnd-none = "󰂛";
          inhibited-notification = "󱅫";
          inhibited-none = "";
          dnd-inhibited-notification = "󰵙";
          dnd-inhibited-none = "󰂛";
        };
        return-type = "json";
        exec-if = "which swaync-client";
        exec = "swaync-client -swb";
        on-click = "swaync-client -R; swaync-client -rs; swaync-client -t -sw";
        on-click-right = "swaync-client -R; swaync-client -rs; swaync-client -d -sw";
        escape = true;
      };
    };
  };
}
