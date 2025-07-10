{
  config,
  pkgs,
  ...
}:
{
  powerManagement.cpuFreqGovernor = "performance";
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

  environment.systemPackages = with pkgs; [
    egl-wayland
    libGL
    libglvnd
    libva-utils
    mesa
    nvitop
    vdpauinfo
    vulkan-tools
    vulkan-validation-layers
    wgpu-utils
    ntfs3g
  ];

  ## Enable ZRAM
  zramSwap.enable = true;

  ## HDD Mount
  boot.supportedFilesystems = [ "ntfs" ];
  fileSystems."/mnt/hdd" = {
    device = "/dev/disk/by-uuid/01DB3464A12349E0";
    fsType = "ntfs-3g";
    options = [
      "rw"
      "uid=1000"
    ];
  };

  system.stateVersion = "25.11";
}
