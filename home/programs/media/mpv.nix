{
  lib,
  pkgs,
  host,
  ...
}:
{
  stylix.targets.mpv.enable = true;

  programs.mpv = {
    enable = true;

    config = {
      osc = "no";
      hwdec = "auto";
    }
    # Use IGPU on Laptop
    // lib.optionalAttrs (host == "xps7590") {
      # device is from mpv --vulkan-device=help
      vulkan-device = "86809b3e-0000-0000-0002-000000000000";
    };

    # Rebinding these since modernx overrides them
    bindings = {
      "Shift+LEFT" = "sub-seek -1";
      "Shift+RIGHT" = "sub-seek 1";
    };

    profiles = {
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

    scripts = with pkgs.mpvScripts; [
      autosub # Auto download subtitles
      autosubsync-mpv # Sync subtitles with 'n'
      mpv-discord # Show mpv in Discord RPC
      mpv-cheatsheet # Show hotkeys with '?'
      modernx-zydezu # Modern OSC
      thumbfast # Thumbnail backend
      videoclip # For video trimming
      webtorrent-mpv-hook # Stream torrents
    ];

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
  };
}
