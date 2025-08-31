{ colors, ... }:
let
  windowOpacity = 0.95;
in
{
  programs.niri.settings.window-rules = [
    # Default
    { draw-border-with-background = false; }

    # Dynamic Cast Target
    {
      matches = [ { is-window-cast-target = true; } ];
      focus-ring = {
        enable = true;
        active.color = colors.base08;
        inactive.color = colors.base08-rgba 0.75;
      };
      shadow = {
        enable = true;
        color = colors.base08-rgba 0.75;
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
      opacity = windowOpacity;
    }

    # Zen PiP
    {
      matches = [
        {
          app-id = "zen-beta";
          title = "^Picture-in-Picture$";
        }
      ];
      open-floating = true;
      default-column-width.fixed = 1280;
      default-window-height.fixed = 720;
      opacity = windowOpacity;
    }

    # Maximized Apps
    {
      matches = [
        {
          app-id = "gimp";
          is-floating = false;
        }
        {
          app-id = "jetbrains-idea";
          is-floating = false;
        }
        { app-id = "mpv"; }
        { app-id = "Spotify"; }
        { app-id = "vesktop"; }
        {
          app-id = "zen-beta";
          is-floating = false;
        }
      ];
      open-maximized = true;
    }

    # 3/4-Width Apps
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
      default-column-width.proportion = 0.75;
    }

    # Half-Width Apps
    {
      matches = [
        { app-id = "nemo"; }
      ];
      default-column-width.proportion = 0.5;
    }

    # Transparent Apps
    {
      matches = [
        { app-id = "codium"; }
        { app-id = "VSCodium"; }
        { app-id = "jetbrains-idea"; }
        { app-id = "nemo"; }
        { app-id = "Spotify"; }
      ];
      opacity = windowOpacity;
    }

    # Games (Heroic Launcher w/ Steam Runtime)
    {
      matches = [ { app-id = "steam_app_0"; } ];
      open-floating = false;
      open-maximized = true;
      open-fullscreen = true;
    }
  ];
}
