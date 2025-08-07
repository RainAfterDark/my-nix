{ config, ... }:
let
  mainFont = config.stylix.fonts.monospace.name;
in
{
  dconf.settings = {
    "org/gnome/TextEditor" = {
      custom-font = "${mainFont}";
      highlight-current-line = true;
      indent-style = "space";
      restore-session = false;
      show-grid = false;
      show-line-numbers = true;
      show-right-margin = true;
      style-scheme = "builder-dark";
      style-variant = "dark";
      tab-width = "uint32 2";
      use-system-font = false;
      wrap-text = true;
    };
  };
}
