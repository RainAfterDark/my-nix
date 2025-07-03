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
      modules = [
        universal
        ./hosts/${host}
        ./modules/core
      ];
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
      modules = [ ./modules/home ];
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
