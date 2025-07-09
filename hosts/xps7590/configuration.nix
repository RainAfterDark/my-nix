{
  pkgs,
  inputs,
  ...
}:
{
  # Default config with NVIDIA Prime
  imports = [ inputs.nixos-hardware.nixosModules.dell-xps-15-7590-nvidia ];

  # For WiFi
  boot.kernelModules = [
    "iwlwifi"
    "iwlmvm"
  ];
  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;

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
