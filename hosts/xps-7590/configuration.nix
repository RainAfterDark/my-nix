{ pkgs, inputs, ... }: {
  boot.kernelPackages =
    pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-x86_64-v3;

  # Default config with NVIDIA Prime
  imports = [ inputs.nixos-hardware.nixosModules.dell-xps-15-7590-nvidia ];

  # No hibernate!
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;
  services.logind.settings.Login = {
    KillUserProcesses = false;
    SleepOperation = "suspend";
  };

  # Use the closed NVIDIA drivers to disable GSP (for D3cold on idle)
  hardware.nvidia = {
    open = false;
    gsp.enable = false;
    powerManagement = {
      enable = false; # Disable persistent allocation for suspend
      finegrained = true;
    };
    moduleParams = {
      # This is still necessary: https://github.com/NixOS/nixpkgs/issues/465310
      nvidia.NVreg_EnableGpuFirmware = 0;
    };
  };

  # Intel iGPU
  boot.kernelParams = [
    "i915.enable_guc=2"
    "i915.enable_fbc=1"
    "i915.fastboot=1"
  ];

  hardware.intelgpu = {
    driver = "i915";
    loadInInitrd = true;
    computeRuntime = "legacy";
    vaapiDriver = "intel-media-driver";
  };

  # Build packages with CUDA support
  nixpkgs.config.cudaSupport = true;

  # Enable dynamic CDI configuration (for docker)
  hardware.nvidia-container-toolkit.enable = true;

  # For Wine etc.
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
  # WARNING! Might be unstable! If this breaks just follow:
  # https://www.reddit.com/r/Dell/comments/fzv599/
  services.undervolt = {
    enable = true;
    temp = 85; # note that GPU throttles around 85
    turbo = 0; # 0 enabled, 1 disabled
    useTimer = true; # periodically reapply settings

    coreOffset = -120; # -150 limit
    uncoreOffset = -40; # -100 limit
    gpuOffset = 0; # doesn't do much
    analogioOffset = 0; # should be left 0
  };

  # TLP
  services.tlp = {
    enable = true;
    settings = {
      # Power profiles
      CPU_SCALING_GOVERNOR_ON_AC = "powersave";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "balanced";

      # Charge thresholds
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 80;

      # Exclude dGPU from power management
      RUNTIME_PM_DENYLIST = "01:00.0";
      RUNTIME_PM_ON_AC = "auto";
      RUNTIME_PM_ON_BAT = "auto";
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

  ## Swap
  zramSwap = {
    enable = true;
    memoryPercent = 25; # 8GB
  };

  ## Utility
  environment.systemPackages = with pkgs; [
    powerstat
    powertop
    brightnessctl
    nvtopPackages.nvidia
  ];
}
