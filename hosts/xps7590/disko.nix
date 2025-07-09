{ inputs, ... }:
{
  imports = [ inputs.disko.nixosModules.disko ];

  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {

            # EFI System Partition
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };

            # Encrypted root container
            luks = {
              size = "100%";
              label = "luks";
              content = {
                type = "luks";
                name = "cryptroot";
                settings = {
                  allowDiscards = true; # enable TRIM
                };

                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ]; # force-create
                  subvolumes = {
                    # Root
                    root = {
                      mountpoint = "/";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };

                    # Home
                    home = {
                      mountpoint = "/home";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };

                    # Nix store
                    nix = {
                      mountpoint = "/nix";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };

                    # Swap file inside a subvolume
                    swap = {
                      mountpoint = "/.swap";
                      swap.swapfile.size = "36G"; # 32GB RAM
                    };
                  };
                };

              };
            };

          };
        };
      };
    };
  };

  boot.initrd.luks.devices.cryptroot = {
    device = "/dev/disk/by-partlabel/luks";
    name = "cryptroot";
    allowDiscards = true; # enable TRIM
    bypassWorkqueues = true; # enables both perf-no_* options
  };
}
