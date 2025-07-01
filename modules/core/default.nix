{ ... }:
{
  imports = [
    ./bootloader

    ./audio.nix
    ./desktop.nix
    ./locale.nix
    ./network.nix
    ./programs.nix
    ./security.nix
    ./services.nix
    ./system.nix
    ./user.nix
  ];
}
