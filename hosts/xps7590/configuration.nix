{ pkgs, inputs, ... }:
{
  imports = [ inputs.nixos-hardware.nixosModules.dell-xps-15-7590-nvidia ];

  environment.systemPackages = with pkgs; [
    git
    home-manager
    curl
    nano
    iw
    wpa_supplicant
  ];

  system.stateVersion = "25.11";
}
