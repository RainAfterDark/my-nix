{
  config,
  flakeRoot,
  ...
}:
let
  quickshellDir = "${flakeRoot}/home/desktop/quickshell";
  quickshellSym = config.lib.file.mkOutOfStoreSymlink quickshellDir;
in
{
  xdg.configFile."quickshell" = {
    source = quickshellSym;
    force = true;
  };

  # programs.niri.settings = {
  #   spawn-at-startup = [
  #     { command = [ "qs" ]; }
  #   ];
  # };
}
