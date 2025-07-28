{
  lib,
  pkgs,
  flakeRoot,
  ...
}:
let
  wallpaperDir = "${flakeRoot}/assets/gif";
  ffmpegthumbnailer = lib.getExe pkgs.ffmpegthumbnailer;
  wallpaper-selector = pkgs.writeShellScriptBin "wallpaper-selector" ''
    #!/usr/bin/env bash
    WALLDIR="${wallpaperDir}"
    THUMBDIR="$HOME/.cache/wallpaper-thumbnails"
    mkdir -p "$THUMBDIR"

    choice=$(
      find "$WALLDIR" -type f \( -iname '*.jpg' -o -iname '*.png' -o -iname '*.jpeg' -o -iname '*.gif' \) |
      while IFS= read -r img; do
        base=$(basename "$img")
        thumb="$THUMBDIR/''${base%.*}.png"
        if [ ! -f "$thumb" ]; then
          ${ffmpegthumbnailer} -i "$img" -o "$thumb" -s 128 -t 0s
        fi
        echo -e "$base\0icon\x1f$thumb\0data\x1f$img"
      done | walker -d
    )

    if [ -n "$choice" ]; then
      swww img -t any -f Nearest "$WALLDIR/$choice"
    fi
  '';
in
{
  home.packages = [ wallpaper-selector ];
}
