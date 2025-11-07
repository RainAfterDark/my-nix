{ pkgs, lib, ... }:
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
      ];

      settings = {
        inputMethod = {
          GroupOrder."0" = "Default";
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "us";
            DefaultIM = "keyboard-us";
          };
          "Groups/0/Items/0".Name = "keyboard-us";
          "Groups/0/Items/1".Name = "mozc";
        };

        # Kinda fucked up that these need to be capitalized
        addons.classicui.globalSection = {
          PreferTextIcon = "True";
          UseDarkTheme = lib.mkForce "False";
          UseAccentColor = lib.mkForce "False";
        };
      };

    };
  };
}
