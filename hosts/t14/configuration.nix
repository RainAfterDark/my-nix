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
      mesa.opencl # Enables Rusticl (OpenCL) support
    ];
  };

  environment.variables = {
    RUSTICL_ENABLE = "radeonsi";
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
      CPU_SCALING_GOVERNOR_ON_AC = "schedutil";
      CPU_SCALING_GOVERNOR_ON_BAT = "schedutil";
      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "low-power";
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };

  ## Fingerprint Scanner
  services.fprintd.enable = true;
  security.pam.services.sudo.fprintAuth = true;
  security.pam.services.swaylock.fprintAuth = true;

  ## Swap
  zramSwap = {
    enable = true;
    memoryPercent = 25;
  };

  ## Utility
  environment.systemPackages = with pkgs; [
    amdgpu_top
    radeontop
    powerstat
    powertop
  ];

  ## Firmware updates
  # services.fwupd.enable = true;
}
