{ lib, pkgs, ... }:
{
  home.packages = with pkgs; [ nemo ];
  dconf.settings = with lib.gvariant; {
    "org/cinnamon/desktop/applications/terminal" = {
      exec = "${pkgs.kitty}/bin/kitty";
    };
    "org/nemo/preferences" = {
      always-use-browser = true;
      click-double-parent-folder = true;
      close-device-view-on-device-eject = true;
      date-font-choice = "auto-mono";
      date-format = "iso";
      last-server-connect-method = 3;
      quick-renames-with-pause-in-between = true;
      show-edit-icon-toolbar = false;
      show-full-path-titles = false;
      show-hidden-files = true;
      show-home-icon-toolbar = true;
      show-new-folder-icon-toolbar = true;
      show-open-in-terminal-toolbar = true;
      show-search-icon-toolbar = false;
      show-show-thumbnails-toolbar = false;
      thumbnail-limit = mkUint64 68719476736;
      tooltips-in-icon-view = true;
      tooltips-in-list-view = true;
      tooltips-show-file-type = true;
      tooltips-show-mod-date = true;
    };
    "org/nemo/preferences/menu-config" = {
      background-menu-open-as-root = false;
      selection-menu-open-as-root = false;
      selection-menu-open-in-terminal = true;
      selection-menu-scripts = false;
    };
    "org/nemo/search" = {
      search-reverse-sort = false;
      search-sort-column = "name";
    };
    "org/nemo/window-state" = {
      maximized = true;
      network-expanded = true;
      side-pane-view = "places";
      sidebar-bookmark-breakpoint = 2;
      sidebar-width = 220;
      start-with-sidebar = true;
    };
  };

  programs.niri.settings = {
    window-rules = [
      {
        matches = [ { app-id = "nemo"; } ];
        default-column-width = {
          proportion = 0.5;
        };
      }
    ];
  };
}
