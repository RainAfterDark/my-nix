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

    ## Desktop
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    milk-grub-theme.url = "github:gemakfy/MilkGrub";
    sddm-stray-nixos.url = "github:RainAfterDark/sddm-stray-nixos";

    elephant.url = "github:abenz1267/elephant/dev";
    walker = {
      url = "github:abenz1267/walker/dev";
      inputs.elephant.follows = "elephant";
    };

    ## Programs
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixcord.url = "github:kaylorben/nixcord";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";

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
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://cache.garnix.io"
      "https://cache.flox.dev"
      "https://attic.xuyh0120.win/lantian"
      "https://niri.cachix.org"
      "https://ezkea.cachix.org"
      "https://walker.cachix.org"
      "https://walker-git.cachix.org"
    ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "flox-cache-public-1:7F4OyH7ZCnFhcze3fJdfyXYLQw/aV7GEed86nQ7IsOs="
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
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
        "t14"
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
            inputs.niri.overlays.niri
            (import ./pkgs/overlays.nix)
          ];
          config = {
            permittedInsecurePackages = [
              "ventoy-gtk3-1.1.10"
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
