{
  description = "My Nix";

  inputs = {
    ## Core
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ## Servers
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";

    ## Desktop
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    milk-grub-theme.url = "github:gemakfy/MilkGrub";
    sddm-stray-nixos.url = "github:RainAfterDark/sddm-stray-nixos";

    elephant.url = "github:abenz1267/elephant";
    walker = {
      url = "github:abenz1267/walker";
      inputs.elephant.follows = "elephant";
    };

    ## Programs
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixcord.url = "github:kaylorben/nixcord";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    textfox.url = "github:adriankarlen/textfox";

    ## Dev
    flox = {
      url = "github:flox/flox/v1.7.2";
    };

    ## Certain Anime Game
    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    substituters = [
      "https://cache.nixos.org?priority=100"
      "https://nix-community.cachix.org?priority=90"
      "https://cache.garnix.io?priority=80"
      "https://cache.flox.dev?priority=70"
      "https://niri.cachix.org?priority=10"
      "https://ezkea.cachix.org?priority=10"
      "https://walker.cachix.org?priority=10"
      "https://walker-git.cachix.org?priority=10"
    ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "flox-cache-public-1:7F4OyH7ZCnFhcze3fJdfyXYLQw/aV7GEed86nQ7IsOs="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
      "walker.cachix.org-1:fG8q+uAaMqhsMxWjwvk0IMb4mFPFLqHjuvfwQxE4oJM="
      "walker-git.cachix.org-1:vmC0ocfPWh0S/vRAQGtChuiZBTAe4wiKDeyyXM0/7pM="
    ];
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      username = "ame";
      flakeRoot = "/home/${username}/my-nix";
      stateVersion = "25.11";
      hosts = [
        "desktop"
        "xps7590"
      ];

      universal = {
        nix = {
          settings = {
            sandbox = true;
            auto-optimise-store = true;
            trusted-users = [ username ];
            allowed-users = [ username ];
            experimental-features = [
              "nix-command"
              "flakes"
            ];
          };
        };

        nixpkgs = {
          overlays = [
            inputs.nix-cachyos-kernel.overlay
            inputs.nix-minecraft.overlay
            inputs.niri.overlays.niri
            (import ./pkgs/overlays.nix)
          ];
          config = {
            permittedInsecurePackages = [
              # This version of Gradle no longer
              # receives security updates...
              "gradle-7.6.6"
              "ventoy-gtk3-1.1.07"
            ];
            allowUnfree = true;
            nvidia.acceptLicense = true;
            android_sdk.accept_license = true;
          };
        };
      };

    in
    import ./outputs.nix {
      inherit
        self
        nixpkgs
        inputs
        universal
        system
        username
        flakeRoot
        stateVersion
        hosts
        ;
    };
}
