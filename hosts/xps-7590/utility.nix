{ pkgs, ... }:
{
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
      # GPU Test
      unigine-superposition
      superposWrapper
      # Monitoring/Control
      powerstat
      powertop
      brightnessctl
    ];
}
