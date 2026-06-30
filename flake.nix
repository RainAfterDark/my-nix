{
  description = "My Nix";

  outputs =
    { self, ... }@inputs:
    import ./nix/outputs.nix rec {
      inherit self inputs;
      username = "ame";
      flakeRoot = "/home/${username}/my-nix";
    };

  inputs = {
    ## Core
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    flox.url = "github:flox/flox/latest";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
    niri-flake = {
      # TODO: seems no longer updated, probably use something else
      url = "github:sodiboo/niri-flake/very-refactor";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:niri-wm/niri";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    milk-grub-theme = {
      url = "github:gemakfy/MilkGrub";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sddm-stray-nixos = {
      url = "github:RainAfterDark/sddm-stray-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # noctalia-qs = {
    #   url = "github:noctalia-dev/noctalia-qs";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # noctalia = {
    #   url = "github:RainAfterDark/noctalia-shell/feat/lock-screencopy-blur";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.noctalia-qs.follows = "noctalia-qs";
    # };

    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vicinae.url = "github:vicinaehq/vicinae"; # Cached
    vicinae-extensions = {
      url = "github:vicinaehq/extensions";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.vicinae.follows = "vicinae";
    };

    awww = {
      url = "git+https://codeberg.org/LGFae/awww";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ## Programs
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nixcord = {
      url = "github:FlameFlag/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ## Certain "Anime Games"...
    aagl.url = "github:ezKEa/aagl-gtk-on-nix"; # Cached

    ## Misc.
    linux-wallpaper-engine.url = "github:jagrat7/linux-wallpaper-engine";
    linux-wallpaperengine = {
      # submodules workaround: https://github.com/NixOS/nix/issues/14982
      url = "git+https://github.com/Almamu/linux-wallpaperengine?submodules=1";
      flake = false;
    };
  };

  nixConfig = {
    substituters = [
      "https://cache.nixos.org"
      "https://cache.nixos-cuda.org"
      "https://nix-community.cachix.org"
      "https://cuda-maintainers.cachix.org"
      "https://cache.flox.dev"
      "https://attic.xuyh0120.win/lantian"
      "https://niri.cachix.org"
      "https://ezkea.cachix.org"
      "https://vicinae.cachix.org"
      "https://noctalia.cachix.org"
    ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      "flox-cache-public-1:7F4OyH7ZCnFhcze3fJdfyXYLQw/aV7GEed86nQ7IsOs="
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
      "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];

    auto-optimise-store = true;
    use-xdg-base-directories = true;
  };
}
