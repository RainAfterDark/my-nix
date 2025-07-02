{ ... }:
{
  imports = [
    ./bootloader

    ./audio.nix
    ./desktop.nix
    ./locale.nix
    ./network.nix
    ./programs.nix
    ./system.nix
    ./user.nix
  ];
}
