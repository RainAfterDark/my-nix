{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    coreutils
  ];

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

    ## Silent Boot
    # this took forever to figure out
    # most settings probably unneeded
    kernelParams = [
      "quiet"
      "splash"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "boot.shell_on_fail"
      "loglevel=0"
      "systemd.show_status=false"
      "vt.global_cursor_default=0"
      "nowatchdog"
      "nmi_watchdog=0"
    ];
    consoleLogLevel = 0;
    initrd.verbose = false;
    initrd.systemd.enable = true;
    kernel.sysctl."kernel.printk" = "0 0 0 0";
  };

  ## Dummy (a)getty on tty1 to avoid login flicker
  systemd.services."getty@tty1" = {
    overrideStrategy = "asDropin";
    serviceConfig = {
      ExecStart = [
        ""
        "${pkgs.util-linux}/sbin/agetty"
        "--noissue" # suppress /etc/issue
        "--noclear" # don’t blank the screen
        "--skip-login" # do not run /bin/login
        "-l"
        "/run/wrappers/bin/false"
        "tty1"
        "$TERM"
      ];
    };
  };
}
