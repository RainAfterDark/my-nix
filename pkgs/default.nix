{ inputs, lib, ... }:
let
  dir = builtins.readDir ./.;
  isDir = _: type: type == "directory";
  names = builtins.attrNames (lib.filterAttrs isDir dir);
  overlay =
    final: prev:
    lib.genAttrs names (
      name:
      final.callPackage (./. + "/${name}") (
        {
          inherit inputs;
        }
        # If a package depends on itself (presumably to override)
        # then that dependency has to point to the prev version
        # (example: nitch pkg is an override that applies a patch)
        // (final.lib.optionalAttrs (builtins.hasAttr name prev) {
          "${name}" = prev.${name};
        })
      )
    );
in
{
  inherit names overlay;
}
