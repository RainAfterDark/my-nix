{
  config,
  pkgs,
  username,
  ...
}:
let
  mediaGid = 60001;
in
{
  boot.kernelPackages =
    pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-x86_64-v3;

  ## Packages
  environment.systemPackages = with pkgs; [
    ntfs3g # for ntfsfix
    compose2nix # docker yml to nix
  ];

  ## CPU
  powerManagement.cpuFreqGovernor = "performance";

  ## GPU
  services.xserver.videoDrivers = [
    "amdgpu"
    "nvidia"
  ];

  hardware = {
    nvidia = {
      open = false;
      nvidiaSettings = true;
      modesetting.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;

      powerManagement = {
        enable = false;
        finegrained = false;
      };

      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };

        # NVIDIA GTX 750 Ti
        nvidiaBusId = "PCI:1:0:0";
        # AMD Radeon Vega (Renoir)
        amdgpuBusId = "PCI:8:0:0";
      };
    };

    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        libvdpau-va-gl
        libva-vdpau-driver
        nvidia-vaapi-driver
      ];
    };

    enableRedistributableFirmware = true;
  };

  ## Swap
  zramSwap = {
    enable = true;
    memoryPercent = 25; # 4GB
  };

  # Create media GID
  users.groups.media.gid = mediaGid;
  users.users.jellyfin.extraGroups = [ "media" ];
  users.users.${username}.extraGroups = [ "media" ];

  ## HDD Mount
  boot.supportedFilesystems = [ "ntfs3" ];
  fileSystems."/mnt/hdd" = {
    device = "/dev/disk/by-uuid/01DB3464A12349E0";
    fsType = "ntfs3";
    options = [
      "rw"
      "uid=1000"
      "gid=${toString mediaGid}"
      "umask=002"
      "iocharset=utf8"
      "prealloc"
      "noatime"
      "nocase"
      "windows_names"
    ];
  };
}
