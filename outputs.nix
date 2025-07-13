{
  self,
  nixpkgs,
  inputs,
  universal,
  system,
  username,
  flakeRoot,
  stateVersion,
  hosts,
}:
let
  findModules =
    let
      inherit (nixpkgs.lib) filter strings filesystem;
      inherit (strings) hasSuffix;
      inherit (filesystem) listFilesRecursive;
    in
    path: filter (n: hasSuffix ".nix" n) (listFilesRecursive path);

  mkSystemConfig =
    host:
    nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit
          self
          inputs
          host
          username
          flakeRoot
          stateVersion
          ;
        homeModules = findModules ./home;
      };
      modules =
        let
          coreModules = findModules ./core;
          hostModules = findModules ./hosts/${host};
        in
        [ universal ] ++ coreModules ++ hostModules;
    };
in
{
  nixosConfigurations = builtins.listToAttrs (
    map (host: {
      name = host;
      value = mkSystemConfig host;
    }) hosts
  );
}
