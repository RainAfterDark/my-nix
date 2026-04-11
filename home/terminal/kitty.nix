{ ... }:
{
  stylix.targets.kitty.enable = true;
  programs.kitty = {
    enable = true;

    settings = {
      allow_remote_control = true;
      confirm_os_window_close = 0;
      scrollback_lines = 10000;
      enable_audio_bell = false;
      mouse_hide_wait = 60;
      window_padding_width = 8;
      hide_window_decorations = true;

      ## Tabs
      tab_title_template = "{index}";
      active_tab_font_style = "normal";
      inactive_tab_font_style = "normal";
      tab_bar_style = "powerline";
      tab_powerline_style = "angled";

      ## Cursor
      cursor_trail = 1;
      cursor_trail_start_threshold = 0;
    };

    keybindings = {
      ## Tabs
      "alt+1" = "goto_tab 1";
      "alt+2" = "goto_tab 2";
      "alt+3" = "goto_tab 3";
      "alt+4" = "goto_tab 4";

      ## Unbind
      "ctrl+shift+left" = "no_op";
      "ctrl+shift+right" = "no_op";
    };
  };
}
