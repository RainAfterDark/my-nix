{
  description = "My Nix";

  inputs = {
    ## Core
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
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
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    milk-grub-theme.url = "github:gemakfy/MilkGrub";
    sddm-stray-nixos.url = "github:RainAfterDark/sddm-stray-nixos";

    ## Programs
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixcord.url = "github:kaylorben/nixcord";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    walker.url = "github:abenz1267/walker";

    ## Certain Anime Game
    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    substituters = [
      "https://cache.nixos.org?priority=10"
      "https://nix-community.cachix.org"
      "https://chaotic-nyx.cachix.org/"
      "https://niri.cachix.org"
      "https://walker.cachix.org"
      "https://walker-git.cachix.org"
    ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
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
            inputs.niri.overlays.niri
          ] ++ import ./overlays;
          config.allowUnfree = true;
          config.nvidia.acceptLicense = true;
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
