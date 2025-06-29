{ ... }:
{
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
    };
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      useOSProber = true;

      gfxmodeEfi = "1920x1080";
      gfxpayloadEfi = "keep";
      milk-theme.enable = true;

      extraInstallCommands = ''
        cat << EOF >> /boot/grub/grub.cfg
        # Reboot
        menuentry "Reboot" --class restart{
          reboot
        }
        # Shutdown
        menuentry "Shutdown" --class shutdown {
          halt
        }
        EOF
      '';
    };
    timeout = null;
    systemd-boot.enable = false;
  };
}
