{ colors, ... }:
let
  height = 400;
  width = 450;
in
{
  programs.niri.settings = {
    window-rules = [
      {
        matches = [
          { app-id = "walker"; }
          { app-id = "dev.benz.walker"; }
        ];
        open-floating = true;
        default-floating-position = {
          relative-to = "top-left";
          x = 16;
          y = 10;
        };
        max-height = height;
        min-height = height;
        max-width = width;
        min-width = width;
      }
    ];
  };

  programs.walker.theme.layout = with colors; {
    ui = {
      anchors = {
        bottom = true;
        left = true;
        right = true;
        top = true;
      };
      window = {
        h_align = "fill";
        v_align = "fill";

        box = {
          h_align = "center";
          height = height;
          width = width;

          bar = {
            orientation = "horizontal";
            position = "end";

            entry = {
              h_align = "fill";
              h_expand = true;

              icon = {
                h_align = "center";
                h_expand = true;
                pixel_size = 24;
                theme = "";
              };
            };
          };

          ## No top margin on window mode
          # margins = {
          #   top = 200;
          # };

          ai_scroll = {
            name = "aiScroll";
            h_align = "fill";
            v_align = "fill";
            max_height = 300;
            min_width = 400;
            height = 300;
            width = 400;

            margins = {
              top = 8;
            };

            list = {
              name = "aiList";
              orientation = "vertical";
              width = 400;
              spacing = 10;

              item = {
                name = "aiItem";
                h_align = "fill";
                v_align = "fill";
                x_align = 0;
                y_align = 0;
                wrap = true;
              };
            };
          };

          scroll = {
            list = {
              marker_color = base0E;
              max_height = 300;
              max_width = 400;
              min_width = 400;
              width = 400;

              item = {
                activation_label = {
                  h_align = "fill";
                  v_align = "fill";
                  width = 20;
                  x_align = 0.5;
                  y_align = 0.5;
                };
                icon = {
                  pixel_size = 26;
                  theme = "";
                };
              };

              margins = {
                top = 8;
              };
            };
          };

          search = {
            prompt = {
              name = "prompt";
              icon = "edit-find";
              theme = "";
              pixel_size = 18;
              h_align = "center";
              v_align = "center";
            };
            clear = {
              name = "clear";
              icon = "edit-clear";
              theme = "";
              pixel_size = 18;
              h_align = "center";
              v_align = "center";
            };
            input = {
              h_align = "fill";
              h_expand = true;
              icons = true;
            };
            spinner = {
              hide = true;
            };
          };
        };
      };
    };
  };
}
