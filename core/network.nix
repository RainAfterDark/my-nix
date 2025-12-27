{
  pkgs,
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
      dns = "systemd-resolved"; # let NM hand DNS to resolved
    };

    firewall = {
      enable = true;
      allowedTCPPorts = [
        22
        80
        443
        config.services.tailscale.port
      ];
      allowedUDPPorts = [
        config.services.tailscale.port
      ];
      trustedInterfaces = [ config.services.tailscale.interfaceName ];
    };
  };

  services.resolved = {
    enable = true;
    fallbackDns = [
      "8.8.8.8"
      "8.8.4.4"
      "1.1.1.1"
      "1.0.0.1"
    ];
  };

  services.tailscale = {
    enable = true;
    # authKeyFile = config.sops.secrets.tailscale-authkey.path;
    # prevent tailscale from overwriting resolv.conf
    extraUpFlags = [ "--accept-dns=false" ];
  };
}
