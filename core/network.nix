{
  pkgs,
  pkgs-stable,
  config,
  host,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    dnsutils
    networkmanagerapplet
  ];

  networking = {
    hostName = host;

    networkmanager = {
      enable = true;
      # let NM hand DNS to resolved
      dns = "systemd-resolved";
    };

    firewall = {
      enable = true;
      checkReversePath = "loose";

      allowedTCPPorts = [
        22
        80
        443
        config.services.tailscale.port
      ];

      allowedUDPPorts = [ config.services.tailscale.port ];

      trustedInterfaces = [ config.services.tailscale.interfaceName ];
    };
  };

  services.resolved = {
    enable = true;
    settings = {
      Resolve = {
        FallbackDNS = [
          "8.8.8.8"
          "8.8.4.4"
          "1.1.1.1"
          "1.0.0.1"
        ];
        # let avahi handle mDNS
        MulticastDNS = "off";
      };
    };
  };

  # mDNS
  services.avahi = {
    enable = true;
    openFirewall = true;
    nssmdns4 = true;
    nssmdns6 = true;

    publish = {
      enable = true;
      userServices = true;
      addresses = true;
    };
  };

  # TailNet
  services.tailscale = {
    enable = true;
    # prevent tailscale from overwriting resolv.conf
    extraUpFlags = [ "--accept-dns=false" ];
  };

  # Stream host for Moonlight
  services.sunshine = {
    enable = true;
    autoStart = false;
    capSysAdmin = true;
    openFirewall = true;
    # FIXME: broken build on unstable
    package = pkgs-stable.sunshine;
  };

  # Wireshark
  programs.wireshark = {
    enable = true;
    dumpcap.enable = true;
    usbmon.enable = true;
    package = pkgs.wireshark;
  };

  # Telemetry blocking
  # (might be better to use something like Blocky/Adguard)
  networking.hosts = {
    "0.0.0.0" = [
      "data-p.gryphline.com"
      "native-log-collect.gryphline.com"
      "eventlog.gryphline.com"
      "event-log-api-ipv6.gryphline.com"
      "event-log-api-data-platform-data-lake-prod.gryphline.com"
    ];
  };
}
