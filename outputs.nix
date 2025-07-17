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
  lib = import ./lib { inherit nixpkgs; };
  inherit (lib) findModules;

  mkSystemConfig =
    host:
    nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit
          self
          lib
          inputs
          host
          username
          flakeRoot
          stateVersion
          ;
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
