# Unholy silent boot config
# This took forever to figure out
# Some settings probably unneeded

{ pkgs, ... }:
{
  boot = {
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

    # Disable watchdogs
    blacklistedKernelModules = [
      # Intel
      "iTCO_wdt"
      "iTCO_vendor_support"
      # AMD
      "sp5100_tco"
      # Other
      "wdat_wdt"
    ];

    consoleLogLevel = 0;
    initrd.verbose = false;
    initrd.systemd.enable = true;

    # Console mute fallback
    kernel.sysctl."kernel.printk" = "0 0 0 0";
  };

  # Hacked (a)getty on tty1 to avoid login flicker
  systemd.services."getty@tty1" = {
    overrideStrategy = "asDropin";
    serviceConfig = {
      ExecStart = [
        ""
        "${pkgs.util-linux}/sbin/agetty"
        "--noissue" # suppress /etc/issue
        "--noclear" # don’t blank the screen
        "--skip-login" # don't run /bin/login
        "-l"
        "/run/wrappers/bin/false"
        "tty1"
        "$TERM"
      ];
    };
  };
}
