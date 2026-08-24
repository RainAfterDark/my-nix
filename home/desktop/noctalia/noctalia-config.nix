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
## Old V4 settings
# {
#   imports = [ inputs.noctalia.homeModules.default ];
#   stylix.targets.noctalia-shell.enable = true;

#   programs.noctalia-shell = {
#     enable = true;
#     systemd.enable = true;
#   };

#   xdg.configFile."noctalia/settings.json".source = lib.mkForce (
#     ln "${cfgPath}/settings.json"
#   );
# }
{
  # imports = [ inputs.noctalia.homeModules.default ];
  programs.noctalia = {
    enable = true;
    systemd.enable = true;
  };
  xdg.stateFile."noctalia/settings.toml".source = ln "${cfgPath}/settings.toml";
}
