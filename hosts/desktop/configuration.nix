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
  ## Packages
  environment.systemPackages = with pkgs; [
    ntfs3g # for HDD mount
    compose2nix # docker yml to nix
  ];

  ## CPU
  powerManagement.cpuFreqGovernor = "performance";

  ## GPU
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware = {
    nvidia = {
      forceFullCompositionPipeline = false;
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        libvdpau-va-gl
        nvidia-vaapi-driver
        libva-vdpau-driver
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
  boot.supportedFilesystems = [ "ntfs" ];
  fileSystems."/mnt/hdd" = {
    device = "/dev/disk/by-uuid/01DB3464A12349E0";
    fsType = "ntfs-3g";
    options = [
      "rw"
      "uid=1000"
      "gid=${toString mediaGid}"
      "umask=002"
      "windows_names"
      "big_writes"
    ];
  };
}
