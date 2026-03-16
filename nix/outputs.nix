{
  self,
  inputs,
  username,
  flakeRoot,
  ...
}:
let
  systems = [ "x86_64-linux" ];
  lib = import ./lib-ext.nix { inherit (inputs) nixpkgs; };
  forEachSystem = f: lib.genAttrs systems (system: f system);

  hosts =
    let
      isDir = name: type: type == "directory";
      hostDir = builtins.readDir ../hosts;
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
          coreModules = findModules ../core;
          hostModules = findModules ../hosts/${host};
        in
        [ ./nix-cfg.nix ] ++ coreModules ++ hostModules;
    };
in
{
  overlays.default = import ./overlays.nix { inherit inputs lib; };

  packages = forEachSystem (
    system:
    let
      opts = import ./pkgs-opts.nix { inherit lib self; };
      pkgs = import inputs.nixpkgs ({ inherit system; } // opts);
      names = (import ../pkgs { inherit inputs lib; }).names;
    in
    lib.genAttrs names (name: pkgs.${name})
  );

  nixosConfigurations = builtins.listToAttrs (
    map (host: {
      name = host;
      value = mkSystemConfig host;
    }) hosts
  );
}
