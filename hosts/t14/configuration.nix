{
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14-amd-gen1 ];

  ## Don't hibernate!
  boot.kernelParams = [
    "nohibernate"
  ];
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;
  services.logind.settings.Login = {
    KillUserProcesses = false;
    SleepOperation = "suspend";
  };

  ## Graphics (AMD Radeon)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      libvdpau-va-gl
      libva-vdpau-driver
    ];
  };

  ## WiFi / Bluetooth
  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General.Experimental = true; # Shows battery % for devices
    };
  };
  services.blueman.enable = true;

  ## Power Management (TLP)
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "balanced";
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };

  ## Swap
  zramSwap = {
    enable = true;
    memoryPercent = 25; # 4GB
  };

  ## Utility
  environment.systemPackages = with pkgs; [
    amdgpu_top
    radeontop
  ];

  ## Firmware updates
  # services.fwupd.enable = true;
}
