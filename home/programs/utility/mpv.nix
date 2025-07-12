{ pkgs, ... }:
{
  programs.mpv = {
    enable = true;

    config = {
      hwdec = "auto";
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

    scripts = [
      pkgs.mpvScripts.videoclip
    ];

    scriptOpts = {
      videoclip = {
        # https://aegisub.org/docs/3.2/ASS_Tags/#\an
        osd_align = 9; # Top-Right
        video_width = "auto";
        video_height = "auto";
        video_bitrate = "10M";
        video_quality = 18;
      };
    };
  };
}
