{
  lib,
  pkgs,
  pkgs-stable,
  host,
  ...
}:
{
  stylix.targets.mpv.enable = true;

  programs.mpv = {
    enable = true;

    config = {
      osc = "no"; # required by modernx
      hwdec = "auto";
    }
    # Use IGPU on Laptop
    // lib.optionalAttrs (host == "xps-7590") {
      # device is from mpv --vulkan-device=help
      vulkan-device = "86809b3e-0000-0000-0002-000000000000";
    };

    # Rebinding these since modernx overrides them
    bindings = {
      "Shift+LEFT" = "sub-seek -1";
      "Shift+RIGHT" = "sub-seek 1";
    };

    scripts =
      with pkgs.mpvScripts;
      [
        # Auto download subs
        (autosub.overrideAttrs (old: {
          # make it manual (hotkey is 'b')
          preInstall = (old.preInstall or "") + ''
            substituteInPlace autosub.lua --replace-fail \
            "auto = true" \
            "auto = false"
          '';
        }))

        # Modern OSC
        (modernx-zydezu.overrideAttrs (old: {
          # bind sub cycling to x (avoid conflicts w/ videoclip)
          # z and x by default bind to + and - sub delay ms,
          # which we won't hopefully have to do with sub syncing
          preInstall = (old.preInstall or "") + ''
            substituteInPlace modernx.lua --replace-fail \
            '"c", "cyclecaptions"' \
            '"x", "cyclecaptions"'
          '';
        }))

        autoload # loads playlist entries from dir
        autosubsync-mpv # Sync subtitles with 'n'
        thumbfast # Thumbnail backend
        videoclip # For video trimming
        webtorrent-mpv-hook # Stream torrents
      ]
      ## FIXME: should be removed soon
      ++ (with pkgs-stable.mpvScripts; [
        mpv-cheatsheet # Show hotkeys with '?'
      ]);

    scriptOpts = {
      modernx = {
        compact_mode = false;
        info_button = true;
        loop_button = true;
        show_on_pause = false;
      };

      thumbfast = {
        network = true; # Enable on remote files.
      };

      videoclip = {
        # https://aegisub.org/docs/3.2/ASS_Tags/#\an
        osd_align = 9; # Top-Right
        video_width = -1;
        video_height = -1;
        video_bitrate = "10M";
        video_quality = 18;
      };

      webtorrent = {
        path = "~/Torrents";
      };
    };

    profiles = {
      # Optimized config for wallpapers
      # (even though currently has no use)
      mpvpaper = {
        audio = "no";
        loop = "inf";

        cache = "no";
        demuxer-max-bytes = "10M";
        demuxer-max-back-bytes = "10M";

        deband = "no";
        interpolation = "no";

        hwdec = "auto";
        gpu-api = "vulkan";

        vd-lavc-fast = true;
        vd-lavc-threads = 1;
        vd-lavc-skiploopfilter = "all";

        no-embeddedfonts = "";
        sub-shaper = "simple";
        sub-auto = "fuzzy";
      };
    };
  };
}
