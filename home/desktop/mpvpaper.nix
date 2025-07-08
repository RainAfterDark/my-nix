{ pkgs, flakeRoot, ... }:
let
  bg = "clementine.mp4";
  bgPath = "${flakeRoot}/assets/mp4/${bg}";
  initMem = toString (100 * 1024); # ~100MB
  maxMem = toString (1024 * 1024); # ~1GB

  mpvpaperLoop = pkgs.writeShellScriptBin "mpvpaper-loop" ''
    #!/usr/bin/env bash
    set -euo pipefail
    ml="[mpvpaper-loop]"

    # how often (in seconds) to check mem usage
    interval=30

    start_mpv() {
      mpvpaper -p -o "profile=mpvpaper" ALL "${bgPath}" &
      echo $!
    }

    # start the first instance
    echo
    start_mpv
    pid=$!
    echo "$ml started mpvpaper (pid=$pid)"

    cleanup() {
      echo
      echo "$ml cleaning up..."
      kill "$pid" 2>/dev/null || true
      kill "$newpid" 2>/dev/null || true
      exit
    }

    trap cleanup INT TERM

    while true; do
      # if the process has died for any other reason, respawn
      if ! kill -0 "$pid" 2>/dev/null; then
        echo "$ml pid=$pid exited unexpectedly → restarting"
        start_mpv
        pid=$!
        echo "$ml new pid=$pid"
      fi

      # check memory
      rss_kb=$(ps -o rss= -p "$pid" | tr -d ' ')
      if [[ -n $rss_kb && $rss_kb -gt ${maxMem} ]]; then
        echo
        echo "$ml pid=$pid RSS=''${rss_kb}KB > ${maxMem}KB"
        echo "$ml spinning up replacement..."
        start_mpv
        newpid=$!

        echo
        echo "$ml waiting for replacement (pid=$newpid) to initialize…"
        for i in {1..20}; do       # try up to 20 times (≈10s)
          rss_kb=$(ps -o rss= -p "$newpid" | tr -d ' ' || true)
          if [[ -n "$rss_kb" && "$rss_kb" -gt ${initMem} ]]; then
            echo "$ml pid=$newpid initialized (RSS=''${rss_kb}KB)"
            break
          fi
          sleep 1
        done

        echo "$ml killing old pid=$pid"
        kill "$pid"

        # switch over to watching the new one
        pid=$newpid
      fi

      sleep "$interval"
    done
  '';
in
{
  home.packages = with pkgs; [
    mpvpaper
    mpvpaperLoop
  ];

  # programs.niri.settings = {
  #   spawn-at-startup = [
  #     { command = [ "mpvpaper-loop" ]; }
  #   ];
  # };
}
