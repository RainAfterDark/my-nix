{ inputs, ... }:
{
  imports = [ inputs.wayland-pipewire-idle-inhibit.homeModules.default ];
  services.wayland-pipewire-idle-inhibit = {
    ## NOTICE: UNUSED
    ## Inconsistent, prefer to use manual inhibitor (waybar toggle)
    enable = false;
    systemdTarget = "graphical-session.target";
    settings = {
      verbosity = "INFO";
      media_minimum_duration = 10;
      idle_inhibitor = "wayland";
    };
  };
}
