{ inputs, pkgs, ... }:
{
  imports = [ inputs.milk-grub-theme.nixosModule ];
  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
      };

      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        useOSProber = true;

        ## Theme
        gfxmodeEfi = "1920x1080";
        gfxpayloadEfi = "keep";
        milk-theme.enable = true;

        ## Extra Entries
        extraInstallCommands = ''
           ${pkgs.coreutils}/bin/cat << EOF >> /boot/grub/grub.cfg
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

      timeout = 10;
    };
  };
}
