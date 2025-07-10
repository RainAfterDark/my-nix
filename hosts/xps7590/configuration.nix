{
  pkgs,
  inputs,
  ...
}:
{
  # Default config with NVIDIA Prime
  imports = [
    inputs.nixos-hardware.nixosModules.dell-xps-15-7590-nvidia
    inputs.aagl.nixosModules.default
  ];

  # Hardware Acceleration for Intel CPU
  hardware.graphics.extraPackages = with pkgs; [
    vaapiIntel
    vaapiVdpau
    libvdpau-va-gl
    intel-media-driver
  ];

  # For WiFi
  boot.kernelModules = [
    "iwlwifi"
    "iwlmvm"
  ];
  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;

  # Make LUKS prompt not ugly
  boot.plymouth = {
    enable = true;
    theme = "square_hud";
    themePackages = with pkgs; [
      (adi1090x-plymouth-themes.override {
        selected_themes = [ "square_hud" ];
      })
    ];
  };

  # Swap
  swapDevices = [
    { device = "/.swap/swapfile"; }
  ];

  # Hibernation
  boot.resumeDevice = "/dev/mapper/cryptroot";
  boot.kernelParams = [
    # sudo btrfs inspect-internal map-swapfile -r /.swap/swapfile
    "resume_offset=533760"
  ];

  # CPU Undervolt
  services.undervolt = {
    enable = true;
    coreOffset = -150; # limit
    uncoreOffset = -100; # limit
    gpuOffset = 0; # doesn't do much
    analogioOffset = 0; # should be left 0
    temp = 85; # above 85 throttles (?)
    turbo = 0; # 0 enabled, 1 disabled
    useTimer = true; # periodically reapply settings
  };

  # Benchmarking Tools
  environment.systemPackages =
    with pkgs;
    let
      superposWrapper = pkgs.writeShellScriptBin "superpos" ''
        env -u WAYLAND_DISPLAY \
        -u QT_QPA_PLATFORM -u QT_PLUGIN_PATH \
        -u QML2_IMPORT_PATH -u QML_IMPORT_PATH \
        nvidia-offload mangohud unigine-superposition
      '';
    in
    [
      unigine-superposition
      superposWrapper
      geekbench
      stress-ng
    ];

  ## Anime Games
  nix.settings = inputs.aagl.nixConfig;
  # programs.anime-game-launcher.enable = true;
  # programs.anime-games-launcher.enable = true;
  programs.honkers-railway-launcher.enable = true;
  # programs.honkers-launcher.enable = true;
  # programs.wavey-launcher.enable = true;
  # programs.sleepy-launcher.enable = true;

  system.stateVersion = "25.11";
}
