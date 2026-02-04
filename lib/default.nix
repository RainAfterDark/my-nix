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
            "base0${builtins.elemAt [ "A" "B" "C" "D" "E" "F" ] (n - 10)}"
        ) 16;

        extensions = builtins.listToAttrs (
          builtins.concatMap (
            base:
            let
              inherit (final.strings) removePrefix;
              c = n: removePrefix "#" (builtins.getAttr "${base}-rgb-${n}" colors);
              rgb = "${c "r"}, ${c "g"}, ${c "b"}";
            in
            [
              {
                name = "${base}-rgb";
                value = "rgb(${rgb})";
              }
              {
                name = "${base}-rgba";
                value = a: "rgba(${rgb}, ${toString a})";
              }
            ]
          ) baseKeys
        );
      in
      colors // extensions;
  }
)
