{
  lib,
  pkgs,
  config,
  colors,
  ...
}:
let
  cursor = {
    name = "Aventurine";
    package = pkgs.aventurine-cursor;
    size = 32;
  };

  alpha = 0.85;
  rounding = 0;
in
{
  stylix = {
    inherit cursor;

    targets = {
      gnome.enable = true;
      qt.enable = true;
      gtk = {
        enable = true;
        flatpakSupport.enable = true;
        extraCss = ''
          /* css */
          @define-color window_bg_color ${colors.base00-rgba alpha};
          window.background { border-radius: ${toString rounding}; }
        '';
      };
    };

    icons = {
      enable = true;
      light = "Vimix-white";
      dark = "Vimix-white-dark";
      package = pkgs.vimix-icon-theme;
    };

    opacity = {
      applications = alpha;
      terminal = alpha;
      popups = alpha;
    };
  };

  programs.niri.settings = {
    cursor = {
      theme = cursor.name;
      inherit (cursor) size;
    };
  };

  # TODO: stylix no longer uses xdg.configFile for these settings
  # Patch stylix's .kvconfig with transparecny + blur
  # xdg.configFile."Kvantum/Base16KvantumPatched".source =
  #   let
  #     stylixTheme = config.xdg.configFile."Kvantum/Base16Kvantum".source;
  #   in
  #   pkgs.runCommand "patched-kvantum-theme" { } ''
  #     # bash
  #     mkdir -p $out
  #     cp ${stylixTheme}/Base16Kvantum.svg $out/Base16KvantumPatched.svg
  #     cp ${stylixTheme}/Base16Kvantum.kvconfig $out/Base16KvantumPatched.kvconfig

  #     sed -i 's|^translucent_windows=.*|translucent_windows=true|' \
  #       $out/Base16KvantumPatched.kvconfig

  #     sed -i 's|^blurring=.*|blurring=true|' \
  #       $out/Base16KvantumPatched.kvconfig
  #   '';

  # xdg.configFile."Kvantum/kvantum.kvconfig".source = lib.mkForce (
  #   (pkgs.formats.ini { }).generate "kvantum.kvconfig" {
  #     General.theme = "Base16KvantumPatched";
  #   }
  # );
}
