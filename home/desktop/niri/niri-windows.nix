{ colors, ... }:
{
  programs.niri.settings.window-rules = [
    # Default
    { draw-border-with-background = false; }

    # Dynamic Cast Target
    {
      matches = [ { is-window-cast-target = true; } ];
      focus-ring = {
        enable = true;
        active.color = colors.base0E;
        inactive.color = colors.base0E-rgba 0.75;
      };
      shadow = {
        enable = true;
        color = colors.base0E-rgba 0.75;
        spread = 4;
        softness = 0;
        offset = {
          x = 0;
          y = 0;
        };
      };
    }

    # Pavucontrol
    {
      matches = [
        { app-id = "org.pulseaudio.pavucontrol"; }
      ];
      open-floating = true;
      default-floating-position = {
        relative-to = "top-right";
        x = 316;
        y = 8;
      };
      min-width = 800;
      min-height = 600;
      opacity = 0.95;
    }

    # Nemo
    {
      matches = [ { app-id = "nemo"; } ];
      default-column-width = {
        proportion = 0.5;
      };
      opacity = 0.95;
    }

    # VS Code
    {
      matches = [
        {
          app-id = "codium";
          is-floating = false;
        }
        {
          app-id = "VSCodium";
          is-floating = false;
        }
      ];
      default-column-width = {
        proportion = 0.75;
      };
      opacity = 0.95;
    }

    # IntelliJ IDEA
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

    # Zen Browser
    {
      matches = [ { app-id = "zen-beta"; } ];
      open-maximized = true;
      open-on-workspace = "a";
    }

    # Discord
    {
      matches = [ { app-id = "vesktop"; } ];
      open-maximized = true;
      open-on-workspace = "a";
    }

    # Spotify
    {
      matches = [ { app-id = "Spotify"; } ];
      open-maximized = true;
      open-on-workspace = "a";
      opacity = 0.95;
    }

    # MPV
    {
      matches = [ { app-id = "mpv"; } ];
      open-maximized = true;
    }
  ];
}
