{
  pkgs,
  config,
  host,
  ...
}:
{
  environment.systemPackages = with pkgs; [ networkmanagerapplet ];

  networking = {
    hostName = "${host}";
    networkmanager.enable = true;
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

  services.tailscale = {
    enable = true;
    authKeyFile = config.sops.secrets.tailscale-authkey.path;
  };
}
