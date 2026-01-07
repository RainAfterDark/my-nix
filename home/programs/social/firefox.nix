{
  config,
  inputs,
  colors,
  ...
}:
{
  ## NOTICE: UNUSED
  ## If I wanna use Firefox I want to be able to achieve
  ## transparent tabs with the textfox theme....
  imports = [ inputs.textfox.homeManagerModules.default ];

  textfox = {
    enable = false;
    profiles = [ "default" ];
    config = with colors; {
      tabs = {
        horizontal.enable = false;
        vertical.enable = true;
      };
      displayWindowControls = true;
      displayNavButtons = true;
      displayUrlbarIcons = true;
      displaySidebarTools = false;
      displayTitles = true;
      font = {
        family = config.stylix.fonts.monospace.name;
        size = "13px";
        accent = base0E;
      };
    };
  };

  programs.firefox = {
    enable = false;
    profiles = {
      "default" = {
        id = 0;
        isDefault = true;
      };
    };
  };
}
