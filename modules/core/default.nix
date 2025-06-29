{ ... }:
{
  imports = [
    ./audio.nix
    ./bootloader.nix
    ./display.nix
    ./locale.nix
    ./network.nix
    ./programs.nix
    ./security.nix
    ./services.nix
    ./system.nix
    ./user.nix
  ];
}
