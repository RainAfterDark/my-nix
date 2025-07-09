{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    git
    home-manager
    curl
    nano
    networkmanager
    nmcli
    iw
    wpa_supplicant
  ];

  system.stateVersion = "25.11";
}
