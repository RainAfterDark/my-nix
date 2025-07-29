{ pkgs, ... }:
{
  # Wish there was a more declarative way for this...
  home.packages = with pkgs; [ jetbrains-toolbox ];
  programs.niri.settings = {
    window-rules = [
      {
        matches = [
          {
            app-id = "jetbrains-idea";
            is-floating = false;
          }
        ];
        open-maximized = true;
        opacity = 0.95;
      }
    ];
  };
}
