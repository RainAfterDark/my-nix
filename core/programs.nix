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
    pciutils # lspci, etc.
    wev # input tester
    lact # GPU OC/UV
  ];

  # Init start LACT
  systemd.services.lact = {
    description = "GPU Control Daemon";
    after = [ "multi-user.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.lact}/bin/lact daemon";
    };
    enable = true;
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [ ];
}
