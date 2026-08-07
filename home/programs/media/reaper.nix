{ pkgs, ... }: {
  # Will learn this at some point maybe
  # home.packages = with pkgs; [
  #   (symlinkJoin {
  #     name = "reaper";
  #     paths = [ reaper ];
  #     buildInputs = [ makeWrapper ];
  #     postBuild = ''
  #       # bash
  #       wrapProgram $out/bin/reaper \
  #         --set GDK_BACKEND x11 \
  #         --set GDK_SCALE 1
  #     '';
  #   })
  #   reaper-reapack-extension
  # ];

  # home.file.".config/REAPER/UserPlugins/reaper_reapack-x86_64.so".source =
  #   "${pkgs.reaper-reapack-extension}/UserPlugins/reaper_reapack-x86_64.so";
}
