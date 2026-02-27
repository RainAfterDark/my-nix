{
  inputs,
  config,
  colors,
  ...
}:
let
  fontFamily = config.stylix.fonts.monospace.name;
  bgAlpha = config.stylix.opacity.applications - 0.20;
  customTheme = with colors; ''
    /* css */
    :root {
      /* ─── Base16 accents ─── */
      --red-base:    ${base08};
      --yellow-base: ${base0A};
      --green-base:  ${base0B};
      --blue-base:   ${base0D};
      --purple-base: ${base0E};

      /* ─── Background ─── */
      --bg-1: ${base03};
      --bg-2: ${base02};
      --bg-3: ${base01};
      --bg-4: ${base00-rgba bgAlpha};

      /* ─── Text ─── */
      --text-1: ${base07};
      --text-2: ${base06};
      --text-3: ${base05};
      --text-4: ${base04};
      --text-5: ${base04-rgba 0.4};

      /* ─── RED ramp (base08 ≈ L=65%) ─── */
      --red-1: color-mix(in srgb, var(--red-base) 95%, white 5%);
      --red-2: var(--red-base);
      --red-3: var(--red-base);
      --red-4: color-mix(in srgb, var(--red-base) 95%, black 5%);
      --red-5: color-mix(in srgb, var(--red-base) 85%, black 15%);

      /* ─── YELLOW ramp (base0A ≈ L=59%) ─── */
      --yellow-1: color-mix(in srgb, var(--yellow-base) 92%, white 8%);
      --yellow-2: var(--yellow-base);
      --yellow-3: var(--yellow-base);
      --yellow-4: color-mix(in srgb, var(--yellow-base) 92%, black 8%);
      --yellow-5: color-mix(in srgb, var(--yellow-base) 85%, black 15%);

      /* ─── GREEN ramp (base0B ≈ L=55%) ─── */
      --green-1: color-mix(in srgb, var(--green-base) 91%, white 9%);
      --green-2: var(--green-base);
      --green-3: var(--green-base);
      --green-4: color-mix(in srgb, var(--green-base) 91%, black 9%);
      --green-5: color-mix(in srgb, var(--green-base) 82%, black 18%);

      /* ─── BLUE ramp (base0D ≈ L=63%) ─── */
      --blue-1: color-mix(in srgb, var(--blue-base) 94%, white 6%);
      --blue-2: var(--blue-base);
      --blue-3: var(--blue-base);
      --blue-4: color-mix(in srgb, var(--blue-base) 90%, black 10%);
      --blue-5: color-mix(in srgb, var(--blue-base) 81%, black 19%);

      /* ─── PURPLE ramp (base0E ≈ L=68%) ─── */
      --purple-1: color-mix(in srgb, var(--purple-base) 93%, white 7%);
      --purple-2: var(--purple-base);
      --purple-3: var(--purple-base);
      --purple-4: color-mix(in srgb, var(--purple-base) 93%, black 7%);
      --purple-5: color-mix(in srgb, var(--purple-base) 85%, black 15%);
    }

    body {
      --font:       '${fontFamily}';
      --code-font:  '${fontFamily}';
      --transparency-tweaks: on;
    }
  '';
in
{
  imports = [ inputs.nixcord.homeModules.nixcord ];

  programs.nixcord = {
    enable = true;

    # Theming
    quickCss = customTheme;
    config = {
      frameless = true;
      transparent = true;
      useQuickCss = true;
      enableReactDevtools = true;
      themeLinks = [
        "https://raw.githubusercontent.com/refact0r/system24/refs/heads/main/theme/flavors/system24-vencord.theme.css"
      ];
    };

    # Vanilla discord has better RPC
    discord = {
      enable = true;
      branch = "canary";
      openASAR.enable = true;
    };

    # Unused for now
    vesktop = {
      enable = false;
      settings = {
        appBadge = false;
        arRPC = true;
        customTitleBar = false;
        disableMinSize = false;
        enableSplashScreen = false;
        minimizeToTray = false;
        tray = false;
        hardwareAcceleration = false;
        discordBranch = "canary";
      };
    };
  };
}
