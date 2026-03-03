{
  inputs,
  lib,
  config,
  flakeRoot,
  ...
}:
let
  ln = config.lib.file.mkOutOfStoreSymlink;
  cfgPath = "${flakeRoot}/home/desktop/noctalia";
in
{
  imports = [ inputs.noctalia.homeModules.default ];
  stylix.targets.noctalia-shell.enable = true;

  programs.noctalia-shell = {
    enable = true;
    systemd.enable = true;
  };

  xdg.configFile."noctalia/settings.json".source = lib.mkForce (
    ln "${cfgPath}/settings.json"
  );
}
