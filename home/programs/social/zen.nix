{ inputs, ... }:
{
  imports = [
    inputs.zen-browser.homeModules.beta
    # or inputs.zen-browser.homeModules.twilight
    # or inputs.zen-browser.homeModules.twilight-official
  ];

  programs.zen-browser = {
    enable = true;
  };

  programs.niri.settings = {
    spawn-at-startup = [
      { command = [ "zen" ]; }
    ];
    window-rules = [
      {
        matches = [ { app-id = "zen"; } ];
        open-maximized = true;
        open-on-workspace = "a";
      }
    ];
  };
}
