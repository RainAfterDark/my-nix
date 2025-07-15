{
  config,
  pkgs,
  ...
}:
{
  ## CPU
  powerManagement.cpuFreqGovernor = "performance";

  ## GPU
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware = {
    nvidia = {
      forceFullCompositionPipeline = true;
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        libvdpau-va-gl
        nvidia-vaapi-driver
        vaapiVdpau
      ];
    };
    enableRedistributableFirmware = true;
  };

  ## Swap
  zramSwap = {
    enable = true;
    memoryPercent = 25; # 4GB
  };

  ## HDD Mount
  environment.systemPackages = with pkgs; [ ntfs3g ];
  boot.supportedFilesystems = [ "ntfs" ];
  fileSystems."/mnt/hdd" = {
    device = "/dev/disk/by-uuid/01DB3464A12349E0";
    fsType = "ntfs-3g";
    options = [
      "rw"
      "uid=1000"
    ];
  };
}
