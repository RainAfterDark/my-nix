{ inputs, ... }:
{
  imports = [ inputs.nixcord.homeModules.nixcord ];
  programs.nixcord = {
    enable = true;
    discord.enable = false;
    vesktop.enable = true;
    config = {
      themeLinks = [
        "https://raw.githubusercontent.com/refact0r/system24/refs/heads/main/archive/flavors/monochrome.theme.css"
      ];
    };
  };

  programs.niri.settings = {
    spawn-at-startup = [
      { command = [ "vesktop" ]; }
    ];
    window-rules = [
      {
        matches = [ { app-id = "vesktop"; } ];
        open-maximized = true;
        open-on-workspace = "a";
      }
    ];
  };
}
