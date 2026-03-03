{ host, colors, ... }:
{
  programs.niri.settings = {
    outputs = {
      "Acer Technologies KA252Q G0 24280AC703W01" = {
        mode = {
          width = 1920;
          height = 1080;
          # weird bug when plugged desktop vs laptop
          refresh = if (host == "desktop") then 119.997 else 120.0;
        };
      };
    };

    layout = {
      preset-column-widths = [
        { proportion = 0.5; }
        { proportion = 0.75; }
        { proportion = 1.0; }
        { proportion = 0.25; }
      ];
      default-column-width = {
        proportion = 0.25;
      };

      gaps = 8;
      struts = {
        left = 0;
        right = 0;
        top = 0;
        bottom = 0;
      };

      always-center-single-column = true;
      center-focused-column = "never";
      background-color = "transparent";
      shadow.enable = true;

      focus-ring = {
        enable = true;
        width = 2;
        active.color = colors.base05;
      };
    };

    layer-rules = [
      {
        matches = [
          { namespace = "mpvpaper"; }
          { namespace = "awww-daemon"; }
        ];
        place-within-backdrop = true;
      }
    ];

    workspaces = {
      a = { };
      b = { };
      c = { };
      d = { };
    };

    overview = {
      workspace-shadow.enable = false;
    };
  };
}
