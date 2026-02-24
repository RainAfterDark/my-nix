{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
let
  # Based on services.swww
  # TODO: use the services again when this gets upstreamed
  cfg = {
    package = inputs.awww.packages.${pkgs.stdenv.hostPlatform.system}.awww;
    extraArgs = [ ];
  };
in
{
  home.packages = [ cfg.package ];

  systemd.user.services.awww = {
    Install = {
      WantedBy = [ config.wayland.systemd.target ];
    };

    Unit = {
      ConditionEnvironment = "WAYLAND_DISPLAY";
      Description = "awww-daemon";
      After = [ config.wayland.systemd.target ];
      PartOf = [ config.wayland.systemd.target ];
    };

    Service = {
      ExecStart = "${lib.getExe' cfg.package "awww-daemon"} ${lib.escapeShellArgs cfg.extraArgs}";
      Environment = [ "PATH=$PATH:${lib.makeBinPath [ cfg.package ]}" ];
      Restart = "always";
      RestartSec = 10;
    };
  };
}
