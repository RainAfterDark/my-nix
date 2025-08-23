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
    wayland-pipewire-idle-inhibit = {
      url = "github:rafaelrc7/wayland-pipewire-idle-inhibit";
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
    walker = {
      # TODO: Use 1.0 version when the flake for it is ready
      url = "github:abenz1267/walker/0.13.26";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixcord.url = "github:kaylorben/nixcord";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    textfox.url = "github:adriankarlen/textfox";

    ## Certain Anime Game
    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ## >_<
    nixowos = {
      url = "github:yunfachi/nixowos";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    substituters = [
      "https://cache.nixos.org?priority=100"
      "https://nix-community.cachix.org?priority=90"
      "https://chaotic-nyx.cachix.org?priority=80"
      "https://niri.cachix.org?priority=10"
      "https://ezkea.cachix.org?priority=10"
    ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
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
            inputs.nix-minecraft.overlay
            inputs.niri.overlays.niri
            (import ./pkgs/overlays.nix)
          ];
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
