{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
{
  # Default config with NVIDIA Prime
  imports = [ inputs.nixos-hardware.nixosModules.dell-xps-15-7590-nvidia ];

  # The nixos-hardware defaults this to S3 (deep)
  # S3 sleep has been more unreliable lately....
  boot.kernelParams = lib.mkAfter [
    "mem_sleep_default=s2idle"
    "nohibernate"
  ];

  # Do not use hibernate!
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;
  services.logind.settings.Login = {
    KillUserProcesses = false;
    SleepOperation = "suspend";
  };

  # Disable USB devices from being to wakeup the laptop
  systemd.services.disable-usb-wakeup = {
    description = "Disable USB controller wakeup (XHC) on XPS 7590";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.bash}/bin/bash -c 'if grep -q \"XHC.*enabled\" /proc/acpi/wakeup; then echo XHC > /proc/acpi/wakeup; fi'";
    };
  };

  # Hardware Acceleration for Intel iGPU
  hardware.graphics.extraPackages = with pkgs; [
    libva-vdpau-driver
    libvdpau-va-gl
    intel-vaapi-driver
    intel-media-driver
    nvidia-vaapi-driver
  ];
  hardware.graphics.enable32Bit = true;

  # WiFi/Bluetooth
  boot.kernelModules = [
    "iwlwifi"
    "iwlmvm"
  ];
  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
    bluetooth = {
      enable = true;
      settings = {
        General = {
          Experimental = true;
        };
      };
    };
  };
  services.blueman.enable = true;

  ## CPU Undervolt
  # WARNING! Might be unstable (disabled for now)
  # if this breaks just follow:
  # https://www.reddit.com/r/Dell/comments/fzv599/
  services.undervolt = {
    enable = true;
    coreOffset = 0; # 150 limit
    uncoreOffset = 0; # 100 limit
    gpuOffset = 0; # doesn't do much
    analogioOffset = 0; # should be left 0
    temp = 85; # above 85 throttles (?)
    p1 = {
      limit = 30;
      window = 28;
    };
    p2 = {
      limit = 50;
      window = 10;
    };
    turbo = 0;
    useTimer = true; # periodically reapply settings
  };

  # TLP
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "balanced";
    };
  };

  # Make CPU power stats readable
  systemd.services.fix-rapl-perms = {
    description = "Fix permissions on intel_rapl energy_uj";
    wantedBy = [ "multi-user.target" ];
    after = [ "sysinit.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.coreutils}/bin/chmod 444 /sys/class/powercap/intel-rapl:0/energy_uj";
    };
  };

  ## Swap
  zramSwap = {
    enable = true;
    memoryPercent = 25; # 8GB
  };

  ## FIXME: this is a bit of a hack to get systemctl sleep to run properly again
  systemd.services."nvidia-suspend" = {
    serviceConfig.ExecStart = lib.mkForce "${pkgs.bash}/bin/bash ${config.hardware.nvidia.package}/bin/nvidia-sleep.sh suspend";
  };
  systemd.services."nvidia-resume" = {
    serviceConfig.ExecStart = lib.mkForce "${pkgs.bash}/bin/bash ${config.hardware.nvidia.package}/bin/nvidia-sleep.sh resume";
  };
}
