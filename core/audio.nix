{ username, ... }:
{
  services.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    extraConfig = {
      pipewire."92-low-latency" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.quantum" = 1024;
          "default.clock.min-quantum" = 32;
          "default.clock.max-quantum" = 2048;
        };
        "context.modules" = [
          {
            name = "libpipewire-module-rt";
            args = {
              "nice.level" = -11;
              "rt.prio" = 88;
            };
          }
        ];
      };

      pipewire-pulse."92-low-latency" = {
        "context.properties" = [
          {
            name = "libpipewire-module-protocol-pulse";
            args = { };
          }
        ];
        "pulse.properties" = {
          "pulse.min.req" = "32/48000";
          "pulse.default.req" = "1024/48000";
          "pulse.max.req" = "2048/48000";
          "pulse.min.quantum" = "32/48000";
          "pulse.max.quantum" = "2048/48000";
        };
        "stream.properties" = {
          "node.latency" = "1024/48000";
          "resample.quality" = 4;
        };
      };
    };

  };

  hardware.alsa.enablePersistence = true;

  ## RT Audio Priority
  security.rtkit.enable = true;

  security.pam.loginLimits = [
    {
      domain = "@audio";
      item = "memlock";
      type = "-";
      value = "unlimited";
    }
    {
      domain = "@audio";
      item = "rtprio";
      type = "-";
      value = "99";
    }
    {
      domain = "@audio";
      item = "nice";
      type = "-";
      value = "-19";
    }
  ];

  users.users.${username}.extraGroups = [
    "audio"
    "pipewire"
  ];
}
