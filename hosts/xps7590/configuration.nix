{
  pkgs,
  inputs,
  ...
}:
{
  # Default config with NVIDIA Prime
  imports = [ inputs.nixos-hardware.nixosModules.dell-xps-15-7590-nvidia ];

  # Hardware Acceleration for Intel iGPU
  hardware.graphics.extraPackages = with pkgs; [
    vaapiIntel
    vaapiVdpau
    libvdpau-va-gl
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
  environment.systemPackages = with pkgs; [
    networkmanager_dmenu
    bzmenu
  ];

  # CPU Undervolt
  services.undervolt = {
    enable = true;
    coreOffset = -125; # 150 limit
    uncoreOffset = -75; # 100 limit
    gpuOffset = 0; # doesn't do much
    analogioOffset = 0; # should be left 0
    temp = 75; # above 85 throttles (?)
    useTimer = true; # periodically reapply settings
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
}
