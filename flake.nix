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
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    flox.url = "github:flox/flox/latest";

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
      # TODO: point to main branch when this gets merged
      url = "github:sodiboo/niri-flake/very-refactor";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # WIP blur branch: https://github.com/niri-wm/niri/pull/3483.
    niri-wip = {
      url = "github:niri-wm/niri/wip/branch";
      inputs.nixpkgs.follows = "nixpkgs";
      # can be omitted for end-users
      inputs.rust-overlay.follows = "";
    };

    milk-grub-theme = {
      url = "github:gemakfy/MilkGrub";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sddm-stray-nixos = {
      url = "github:RainAfterDark/sddm-stray-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia-qs = {
      url = "github:noctalia-dev/noctalia-qs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.noctalia-qs.follows = "noctalia-qs";
    };

    # TODO: Deprecated
    elephant.url = "github:abenz1267/elephant"; # Cached
    walker = {
      url = "github:abenz1267/walker";
      inputs.elephant.follows = "elephant";
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
      url = "github:kaylorben/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ## Certain "Anime Games"...
    aagl.url = "github:ezKEa/aagl-gtk-on-nix"; # Cached

    ## Misc.
    linux-wallpaper-engine.url = "github:jagrat7/linux-wallpaper-engine/fix/shell-and-tray";
    linux-wallpaperengine = {
      # FIXME (submodules workaround): https://github.com/NixOS/nix/issues/14982
      url = "git+https://github.com/Almamu/linux-wallpaperengine?submodules=1";
      flake = false;
    };

    hellpaper = {
      url = "github:danihek/hellpaper";
      flake = false;
    };
  };

  nixConfig = {
    substituters = [
      "https://cache.nixos.org"
      "https://cache.nixos-cuda.org"
      "https://nix-community.cachix.org"
      "https://cache.flox.dev"
      "https://attic.xuyh0120.win/lantian"
      "https://niri.cachix.org"
      "https://ezkea.cachix.org"
      "https://walker.cachix.org"
      "https://walker-git.cachix.org"
      "https://vicinae.cachix.org"
    ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "flox-cache-public-1:7F4OyH7ZCnFhcze3fJdfyXYLQw/aV7GEed86nQ7IsOs="
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
      "walker.cachix.org-1:fG8q+uAaMqhsMxWjwvk0IMb4mFPFLqHjuvfwQxE4oJM="
      "walker-git.cachix.org-1:vmC0ocfPWh0S/vRAQGtChuiZBTAe4wiKDeyyXM0/7pM="
      "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
    ];

    auto-optimise-store = true;
    use-xdg-base-directories = true;
  };
}
