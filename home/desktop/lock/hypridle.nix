{
  lib,
  pkgs,
  host,
  config,
  ...
}:
{
  services.hypridle = {
    enable = false;

    settings = {
      general = {
        # Avoid starting multiple hyprlock instances
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session; sleep 1";
        after_sleep_cmd = "niri msg action power-on-monitors";
      };

      listener = [
        {
          timeout = 300; # 5:00
          on-timeout = "niri msg action power-off-monitors";
          on-resume = "niri msg action power-on-monitors";
        }
      ]
      # Laptop-only rules
      ++ lib.optionals (host != "desktop") [
        {
          timeout = 330; # 5:30
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 360; # 6:00
          on-timeout = "sleep-on-bat";
        }
      ];
    };
  };

  # For commands needed in hyprlock
  systemd.user.services.hypridle.Service.Environment =
    lib.mkIf config.services.hypridle.enable (
      lib.mkForce "PATH=${
        lib.makeBinPath (
          with pkgs;
          [
            bash
            procps
            coreutils
            systemd
            hyprlock
            my-scripts
            config.programs.niri.package
          ]
        )
      }"
    );
}
