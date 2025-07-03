{
  self,
  nixpkgs,
  inputs,
  universal,
  system,
  username,
  flakeRoot,
  hosts,
}:
let
  mkPkgs =
    system:
    import nixpkgs {
      inherit system;
      inherit (universal.nixpkgs) overlays config;
    };

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
          ;
      };
      modules =
        let
          hostModules = findModules ./hosts/${host};
          coreModules = findModules ./modules/core;
        in
        [ universal ] ++ hostModules ++ coreModules;
    };

  mkHomeConfig =
    host:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = mkPkgs system;
      extraSpecialArgs = {
        inherit
          self
          inputs
          host
          username
          flakeRoot
          ;
      };
      modules = findModules ./modules/home;
    };

  mkCombined =
    host:
    (mkPkgs system).linkFarm "combined-${host}" [
      {
        name = "system";
        path = self.nixosConfigurations.${host}.config.system.build.toplevel;
      }
      {
        name = "home";
        path = self.homeConfigurations."${username}@${host}".activationPackage;
      }
    ];
in
{
  nixosConfigurations = builtins.listToAttrs (
    map (host: {
      name = host;
      value = mkSystemConfig host;
    }) hosts
  );

  homeConfigurations = builtins.listToAttrs (
    map (host: {
      name = "${username}@${host}";
      value = mkHomeConfig host;
    }) hosts
  );

  combined = builtins.listToAttrs (
    map (host: {
      name = host;
      value = mkCombined host;
    }) hosts
  );
}
