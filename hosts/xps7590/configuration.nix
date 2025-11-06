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

  # CPU Undervolt
  services.undervolt = {
    enable = true;
    coreOffset = -125; # 150 limit
    uncoreOffset = -75; # 100 limit
    gpuOffset = 0; # doesn't do much
    analogioOffset = 0; # should be left 0
    temp = 85; # above 85 throttles (?)
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
