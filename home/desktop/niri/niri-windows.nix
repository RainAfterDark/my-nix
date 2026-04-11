{ config, colors, ... }:
let
  cfg = config.stylix.opacity;
  appAlpha = cfg.applications;
  popupAlpha = cfg.popups;
in
{
  programs.niri.settings.window-rules = [
    ## Default Rule
    { draw-border-with-background = false; }

    ## Specific App Rules
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
      matches = [ { app-id = "org.pulseaudio.pavucontrol"; } ];
      open-floating = true;
      default-floating-position = {
        relative-to = "top-right";
        x = 316;
        y = 8;
      };
      min-width = 800;
      min-height = 600;
      opacity = popupAlpha;
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
      opacity = appAlpha;
    }

    # Android Studio
    {
      matches = [ { app-id = "jetbrains-studio"; } ];
      excludes = [
        { is-floating = true; }
        { title = "^Running Devices - .*"; }
      ];
      default-column-width.proportion = 0.75;
      opacity = appAlpha;
    }

    ## General App Rules
    # Fullscreen Apps
    {
      matches = [
        { app-id = "steam_app_0"; }
        { app-id = "^Minecraft.+"; }
        { app-id = "^Terraria.+"; }
        { app-id = "^starrail.exe$"; }
        { app-id = "^genshinimpact.exe$"; }
      ];
      open-floating = false;
      open-maximized = true;
      open-fullscreen = true;
    }

    # Maximized Apps
    {
      matches = [
        { app-id = "mpv"; }
        { app-id = "gimp"; }
        { app-id = "jetbrains-idea"; }
        { app-id = "jetbrains-rider"; }
        { app-id = "jetbrains-pycharm"; }
        { app-id = "Spotify"; }
        { app-id = "discord"; }
        { app-id = "vesktop"; }
        { app-id = "equibop"; }
        { app-id = "zen-beta"; }
        { app-id = "REAPER"; }
      ];
      excludes = [ { is-floating = true; } ];
      open-maximized = true;
    }

    # 3/4-Width Apps
    {
      matches = [
        { app-id = "codium"; }
        { app-id = "VSCodium"; }
        { app-id = "heroic"; }
        { app-id = "io.missioncenter.MissionCenter"; }
      ];
      excludes = [ { is-floating = true; } ];
      default-column-width.proportion = 0.75;
    }

    # Half-Width Apps
    {
      matches = [ { app-id = "nemo"; } ];
      excludes = [ { is-floating = true; } ];
      default-column-width.proportion = 0.5;
    }

    # Transparent Apps
    {
      matches = [
        { app-id = "codium"; }
        { app-id = "VSCodium"; }
        { app-id = "jetbrains-idea"; }
        { app-id = "jetbrains-rider"; }
        { app-id = "jetbrains-pycharm"; }
        { app-id = "nemo"; }
        { app-id = "Spotify"; }
      ];
      opacity = appAlpha;
    }

    # Floating Apps
    {
      matches = [ { app-id = "waypaper"; } ];
      open-floating = true;
    }
  ];
}
