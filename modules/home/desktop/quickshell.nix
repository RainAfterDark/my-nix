{
  config,
  lib,
  flakeRoot,
  ...
}:
let
  homeDir = config.home.homeDirectory;
  quickshellDir = "${flakeRoot}/modules/home/desktop/quickshell";
  quickshellTarget = "${homeDir}/.config/quickshell";
in
{
  home.activation.symlinkQuickshell = (
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "${homeDir}/.config"
      ln -sfn "${quickshellDir}" "${quickshellTarget}"
    ''
  );

  programs.niri.settings = {
    spawn-at-startup = [
      { command = [ "qs" ]; }
    ];
  };
}
