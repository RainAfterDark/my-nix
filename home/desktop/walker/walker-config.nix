{ inputs, pkgs, ... }:
{
  imports = [ inputs.walker.homeManagerModules.default ];
  home.packages = with pkgs; [
    libqalculate # for calc module
    wtype # for clipboard and emoji modules
    imagemagick # for image previews
  ];

  programs.walker = {
    # Potentially deprecated in favor of vicinae
    enable = false;
    runAsService = true;
    config = {
      theme = "stylix";
    };
    elephant = {
      provider =
        let
          pasteCmd = {
            settings.command = "wl-copy && wtype -M ctrl -M shift v";
          };
        in
        {
          clipboard = pasteCmd;
          symbols = pasteCmd;
          unicode = pasteCmd;
          desktopapplications = {
            settings.wm_integration = true;
          };
        };
    };
  };
}
