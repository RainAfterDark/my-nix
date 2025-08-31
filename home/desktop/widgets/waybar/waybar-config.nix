{ config, colors, ... }:
let
  mainFont = config.stylix.fonts.monospace.name;
  appMapping = {
    codium = "";
    VSCodium = "";
    jetbrains-idea = "";
    jetbrains-toolbox = "";
    obsidian = "󰠮";

    kitty = "";
    imv = "";
    mpv = "";
    nemo = "󰷏";
    gimp = "";

    heroic = "";
    gamescope = "󰺵";
    steam_app_0 = "󰺵";

    Spotify = "";
    steam = "";
    vesktop = "";
    zen-beta = "";
    zoom = "󰰷";

    soffice = "";
    libreoffice-startcenter = "";
    libreoffice-impress = "";
    libreoffice-writer = "";
    libreoffice-calc = "";
    libreoffice-draw = "";
    libreoffice-math = "";
    libreoffice-base = "";
    polkit-gnome-authentication-agent-1 = "󰒃";
    xdg-desktop-portal-gnome = "";

    nm-applet = "";
    nm-connection-editor = "";
    ".blueman-manager-wrapped" = "󰂯";

    "com.obsproject.Studio" = "";
    "com.github.wwmm.easyeffects" = "󰺢";

    "io.github.ilya_zlobintsev.LACT" = "󰾲";
    "io.github.flattool.Warehouse" = "";
    "io.missioncenter.MissionCenter" = "";

    "org.gnome.Nautilus" = "";
    "org.gnome.TextEditor" = "󱩼";
    "org.gnome.FileRoller" = "";
    "org.pulseaudio.pavucontrol" = "";
    "org.qbittorrent.qBittorrent" = "󰰜";

    "org.prismlauncher.PrismLauncher" = "󰍳";
    "Minecraft* 1.21.8" = "󰍳";
    "Minecraft* 1.21.7" = "󰍳";

    "moe.launcher.the-honkers-railway-launcher" = "";
    "The Honkers Railway Launcher" = "";
    "starrail.exe" = "";

    "moe.launcher.an-anime-game-launcher" = "󰫣";
    "An Anime Game Launcher" = "󰫣";
    "genshinimpact.exe" = "󰫣";

    unknown = "";
    "" = "";
  };
in
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
        "idle_inhibitor"
        "tray"
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
        on-click = "walker";
      };

      "niri/workspaces" = {
        format = "{icon}";
        format-icons = {
          "1" = "a";
          "2" = "b";
          "3" = "c";
          "4" = "d";
          "5" = "e";
          "6" = "f";
          "7" = "g";
          "8" = "h";
          "9" = "i";
          "10" = "j";
        };
      };

      "idle_inhibitor" = {
        format = "{icon}";
        format-icons = {
          activated = "";
          deactivated = "";
        };
      };

      "tray" = {
        icon-size = 16;
        spacing = 4;
      };

      "wlr/taskbar" = {
        on-click = "activate";
        on-click-middle = "close";
        sort-by-app-id = true;
        format = "{app_id}";
        app_ids-mapping = appMapping;
        ignore-list = [
          "walker"
          "dev.benz.walker"
          "swaync"
        ];
      };

      "custom/date" = {
        interval = 1;
        tooltip = false;
        exec = "LC_TIME=ja_JP.UTF-8 date +%m月%d";
      };

      clock = {
        interval = 1;
        locale = "ja_JP.utf8";
        format = "󰥔 {:%H:%M:%S}";
        tooltip-format = "<span font='${mainFont}' size='13pt'>{calendar}</span>";
        calendar = {
          mode = "month";
          mode-mon-col = 3;
          on-scroll = 1;
          format = {
            months = "<span color='${base0D}'><b>{}</b></span>";
            days = "<span color='${base07}'>{}</span>";
            weeks = "<span color='${base0B}'><b>W{}</b></span>";
            weekdays = "<span color='${base0C}'><b>{}</b></span>";
            today = "<span color='${base08}'><b>{}</b></span>";
          };
        };
        actions = {
          on-click-middle = "shift_reset";
          on-scroll-up = "shift_down";
          on-scroll-down = "shift_up";
        };
      };

      "custom/day" = {
        interval = 1;
        tooltip = false;
        exec = "LC_TIME=ja_JP.UTF-8 date +%A";
      };

      "custom/cpu" = {
        interval = 2;
        exec = "waybar-cpu";
        return-type = "json";
        format = ''<span bgcolor='${base00}' fgcolor='${base07}'>┇ </span> {percentage:0>2}%'';
      };

      "custom/gpu" = {
        interval = 2;
        exec = "waybar-gpu";
        return-type = "json";
        format = ''<span fgcolor='${base00}' bgcolor='${base07}'>┇󰮄 </span> {percentage:0>2}%'';
      };

      memory = {
        interval = 2;
        format = ''<span bgcolor='${base00}' fgcolor='${base07}'>┇ </span> {percentage:0>2}%'';
      };

      "custom/ping" = {
        interval = 2;
        exec = ''
          ping -c1 -w1 google.com 2>/dev/null | awk 'match($0, /time=([0-9.]+)/, m) {print int(m[1]); found=1} END{if (!found) print -1}'
        '';
        format = "󰖩 {:>2}ms";
        tooltip = false;
      };

      "custom/pipewire" = {
        tooltip = false;
        max-length = 6;
        exec = "waybar-pipewire";
        on-click = "toggle-app pavucontrol";
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
