{
  description = "My Nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    milk-grub-theme.url = "github:gemakfy/MilkGrub";
    sddm-stray-nixos.url = "github:RainAfterDark/sddm-stray-nixos";
  };

  outputs =
    {
      self,
      nixpkgs,
      chaotic,
      niri,
      milk-grub-theme,
      ...
    }@inputs:
    let
      # --------------------------------------------------------------------------
      # Global constants
      # --------------------------------------------------------------------------
      username = "ame";
      system = "x86_64-linux";
      flakeRoot = "$HOME/my-nix";

      # --------------------------------------------------------------------------
      # Common nix / nixpkgs settings
      # --------------------------------------------------------------------------
      universal = {
        nix = {
          settings = {
            sandbox = false;
            auto-optimise-store = false;
            trusted-users = [ username ];
            allowed-users = [ username ];

            experimental-features = [
              "nix-command"
              "flakes"
            ];

            substituters = [
              "https://cache.nixos.org?priority=10"
              "https://nix-community.cachix.org"
              "https://chaotic-nyx.cachix.org/"
              "https://niri.cachix.org"
            ];
            trusted-public-keys = [
              "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
              "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
              "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
              "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
            ];
          };
        };

        nixpkgs = {
          overlays = [ inputs.niri.overlays.niri ];
          config.allowUnfree = true;
          config.nvidia.acceptLicense = true;
        };
      };

      # Helper: import nixpkgs with the same overlay / config as universal
      mkPkgs =
        system:
        import nixpkgs {
          inherit system;
          inherit (universal.nixpkgs) overlays config;
        };

      # --------------------------------------------------------------------------
      # System Builder
      # --------------------------------------------------------------------------
      mkSystemConfig =
        host:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit
              host
              self
              inputs
              username
              flakeRoot
              ;
          };
          modules = [
            universal # common nix + nixpkgs settings
            chaotic.nixosModules.default
            niri.nixosModules.niri
            milk-grub-theme.nixosModule
            ./hosts/${host} # host‑specific modules
            ./modules/core # shared NixOS modules
          ];
        };

      # --------------------------------------------------------------------------
      # Home‑Manager Builder (stand‑alone)
      # --------------------------------------------------------------------------
      mkHomeConfig =
        host:
        inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = mkPkgs system;

          extraSpecialArgs = {
            inherit
              host
              self
              inputs
              username
              flakeRoot
              ;
          };

          modules = [
            niri.homeModules.config
            ./modules/home
          ];
        };

      # --------------------------------------------------------------------------
      # ---------- Combined Derivation (linkFarm) --------------------------------
      # --------------------------------------------------------------------------
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
      # ------------------------------------------------------------------------
      # Outputs
      # ------------------------------------------------------------------------
      nixosConfigurations = {
        desktop = mkSystemConfig "desktop";
      };
      homeConfigurations = {
        "${username}@desktop" = mkHomeConfig "desktop";
      };
      combined = {
        desktop = mkCombined "desktop";
      };
    };
}
