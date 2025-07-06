{ pkgs, ... }:
{
  programs.mpv = {
    enable = true;
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
