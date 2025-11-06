{ pkgs, ... }:
{
  home.sessionVariables = {
    GLFW_IM_MODULE = "ibus";
  };

  stylix.targets.fcitx5.enable = true;

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
        fcitx5-configtool
      ];
    };
  };
}
