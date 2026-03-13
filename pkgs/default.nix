{
  pkgs,
  lib ? pkgs.lib,
  prev ? pkgs,
  inputs ? { },
}:
let
  # Every directory here is a package definition
  dirContents = builtins.readDir ./.;
  isDir = _: type: type == "directory";
  pkgDirs = lib.filterAttrs isDir dirContents;
in
lib.mapAttrs (
  name: _:
  pkgs.callPackage (./. + "/${name}") (
    {
      inherit inputs;
    }
    # If a package depends on itself (presumably to override)
    # then that dependency has to point to the prev version
    # (example: the nitch package is an override that applies a patch)
    // (lib.optionalAttrs (builtins.hasAttr name prev) {
      "${name}" = prev.${name};
    })
  )
) pkgDirs
