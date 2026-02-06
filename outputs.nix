{
  self,
  inputs,
  username,
  flakeRoot,
}:
let
  lib = import ./lib-ext.nix { inherit (inputs) nixpkgs; };

  hosts =
    let
      isDir = name: type: type == "directory";
      hostDir = builtins.readDir ./hosts;
    in
    lib.attrNames (lib.filterAttrs isDir hostDir);

  mkSystemConfig =
    host:
    lib.nixosSystem {
      specialArgs = {
        inherit
          self
          inputs
          lib
          host
          username
          flakeRoot
          ;
      };

      modules =
        let
          inherit (lib) findModules;
          coreModules = findModules ./core;
          hostModules = findModules ./hosts/${host};
        in
        [ ./nix-cfg.nix ] ++ coreModules ++ hostModules;
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
