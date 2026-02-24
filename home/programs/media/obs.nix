{
  pkgs,
  lib,
  osConfig,
  ...
}:
let
  hasNvidiaDriver = lib.elem "nvidia" osConfig.services.xserver.videoDrivers;
in
{
  programs.obs-studio = {
    enable = true;

    package =
      if hasNvidiaDriver then
        pkgs.obs-studio.override { cudaSupport = true; }
      else
        pkgs.obs-studio;

    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-vaapi
      obs-gstreamer
      obs-vkcapture
    ];
  };
}
