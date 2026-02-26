{ config, colors, ... }:
let
  mainFont = config.stylix.fonts.monospace.name;
in
{
  programs.waybar.style = with colors; ''
    /* css */
    * {
      border: none;
      border-radius: 0px;
      min-height: 0px;
      margin: 0px;
      padding: 0px;
      box-shadow: none;
      text-shadow: inherit;
      transition:
        margin 0.25s ease,
        background-size 0.25s ease,
        box-shadow 0.25s ease;
    }

    tooltip {
      background: ${base00-rgba 0.9};
    }

    tooltip label {
      color: ${base07};
    }

    .modules-left {
      margin-left: 12px;
      padding: 0px 10px 0px 14px;
      border-color: ${base07};
      border-style: solid;
      border-width: 0px 0px 4px;
    }

    .modules-center {
      padding: 0px 14px;
      border-color: ${base07};
      border-style: solid;
      border-width: 0px 0px 4px;
    }

    .modules-right {
      margin-right: 12px;
      padding: 0px 10px 0px 14px;
      border-color: ${base07};
      border-style: solid;
      border-width: 0px 0px 4px;
    }

    #waybar {
      background: transparent;
    }

    #custom-border {
      margin-right: 4px;
      border-left: dashed ${base07} 4px;
    }

    #custom-border2 {
      border-left: dashed ${base07} 4px;
    }

    #custom-nixos,
    #custom-notification {
      font-family: "JetBrainsMono Nerd Font";
      font-size: 28px;
      color: ${base00};
      margin: 0px 4px 0px 0px;
      background: linear-gradient(to top,
                  ${base07} 0%,
                  ${base07} 100%) no-repeat;
      background-size: 100% 100%;
      background-position: top center;
      border: solid ${base07} 2px;
    }

    #custom-nixos {
      padding: 0px 15px 0px 6px;
    }

    #custom-notification {
      padding: 0px 15px 0px 8px;
    }

    #custom-nixos:hover,
    #custom-notification:hover {
      color: ${base07};
      background-size: 100% 0%;
      box-shadow: 0px 0px 3px ${base00} inset;
      text-shadow: 0px 0px 3px ${base00};
    }

    #custom-nixos:not(:hover),
    #custom-notification:not(:hover) {
      background-position: bottom center;
    }

    #idle_inhibitor {
      margin: 6px 4px 4px 0px;
      padding: 0px 12px 0px 4px;
      font-size: 20px;
      color: ${base00};
      background: ${base07};
      border: 2px solid ${base07};
    }

    #tray {
      margin: 6px 4px 4px 0px;
      padding: 0px 8px;
      color: ${base07};
      background: ${base00};
      border: 2px solid ${base07};
    }

    #workspaces {
      font-family: "Stray";
      padding-right: 4px;
    }

    #workspaces button {
      font-size: 12px;
      min-width: 13px;
      min-height: 32px;
      padding: 0px 4px;
      margin: 6px 0px -4px 0px;
      color: ${base07};
      background: linear-gradient(to top,
                  ${base07} 0%,
                  ${base07} 100%) no-repeat;
      background-size: 100% 0%;
      background-position: bottom center;
      text-shadow: 0px 0px 3px ${base00};
    }

    #workspaces button.focused {
      font-size: 18px;
      min-width: 26px;
      margin: 6px 0px 4px 0px;
      color: ${base00};
      background-size: 100% 100%;
      text-shadow: none;
      box-shadow: 0px 0px 3px ${base00};
    }

    #workspaces button:not(.focused) {
      background-position: top center;
    }

    #taskbar {
      font-family: "JetBrainsMono Nerd Font";
      padding-right: 4px;
    }

    #taskbar button {
      font-size: 18px;
      color: ${base07};
      padding: 0px 4px;
      margin: 6px 0px -6px 0px;
      background: linear-gradient(to top,
                  ${base07} 0%,
                  ${base07} 100%) no-repeat;
      background-size: 100% 0%;
      background-position: bottom center;
      text-shadow: 0px 0px 3px ${base00};
    }

    #taskbar button.active,
    #taskbar button:hover {
      font-size: 22px;
      padding-left: 5px;
      padding-right: 11px;
      margin: 6px 0px 4px 2px;
      color: ${base00};
      background-size: 100% 100%;
      text-shadow: none;
      box-shadow: 0px 0px 3px ${base00};
    }

    #taskbar button:not(.active) {
      background-position: top center;
    }

    #clock {
      font-family: "${mainFont}";
      font-weight: bold;
      font-size: 20px;
      margin: 4px 4px 4px;
      padding: 0px 6px;
      color: ${base07};
      background: ${base00};
      border: 2px solid ${base07};
      box-shadow: 0px 0px 3px ${base00};
    }

    #custom-date,
    #custom-day {
      font-family: "${mainFont}";
      font-size: 20px;
      margin: 4px 4px 4px;
      padding: 0px 6px;
      color: ${base07};
      background: ${base00};
      border: 2px solid ${base07};
      box-shadow: 0px 0px 3px ${base00};
    }

    #custom-cpu,
    #custom-gpu,
    #memory,
    #custom-ping,
    #custom-pipewire,
    #battery {
      font-family: "${mainFont}";
      font-weight: bold;
      font-size: 15px;
      margin: 6px 4px 4px 0px;
      padding: 0px 4px;
      color: ${base00};
      background: ${base07};
      box-shadow: 0px 0px 3px ${base00};
    }

    #custom-gpu,
    #custom-ping,
    #battery {
      color: ${base07};
      background: ${base00};
      border: 2px solid ${base07};
    }
  '';
}
