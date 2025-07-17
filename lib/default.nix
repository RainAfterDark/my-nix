{ nixpkgs }:
nixpkgs.lib.extend (
  final: prev: {
    findModules =
      let
        inherit (final) filter strings filesystem;
        inherit (strings) hasSuffix;
        inherit (filesystem) listFilesRecursive;
      in
      path: filter (n: hasSuffix ".nix" n) (listFilesRecursive path);

    extendedColors =
      colors:
      let
        baseKeys = builtins.genList (
          n:
          if n < 10 then
            "base0${toString n}"
          else
            "base0${builtins.elemAt [ "a" "b" "c" "d" "e" "f" ] (n - 10)}"
        ) 16;

        rgbaFunctions = builtins.listToAttrs (
          builtins.map (
            base:
            let
              inherit (final.strings) removePrefix;
              c = n: removePrefix "#" (builtins.getAttr "${base}-rgb-${n}" colors);
            in
            {
              name = "${base}-rgba";
              value = alpha: "rgba(${c "r"}, ${c "g"}, ${c "b"}, ${toString alpha})";
            }
          ) baseKeys
        );
      in
      colors // rgbaFunctions;
  }
)
