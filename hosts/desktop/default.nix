{ config, pkgs, ... }:
{
  imports = [
    ./configuration.nix
  ];

  powerManagement.cpuFreqGovernor = "performance";
  services.xserver.videoDrivers = [ "nvidia" ];

  ## Necessary for silent boot, don't think this is
  ## used because this is just a 750 Ti anyway
  boot.blacklistedKernelModules = [ "nouveau" ];

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
