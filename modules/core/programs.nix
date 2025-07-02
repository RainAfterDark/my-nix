{ pkgs, username, ... }:
{
  programs.dconf.enable = true;
  programs.zsh.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    # pinentryFlavor = "";
  };

  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 7d --keep 5";
    };
    flake = "/home/${username}/my-nix";
  };

  environment.systemPackages = with pkgs; [
    coreutils # essentials
    nix-output-monitor # nom
    nvd # nix diff tool
    nix-fast-build
    pciutils # lspci, etc.
  ];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [ ];
}
