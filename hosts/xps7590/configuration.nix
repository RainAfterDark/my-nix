{
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

  system.stateVersion = "25.11";
}
