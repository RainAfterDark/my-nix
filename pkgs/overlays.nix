self: super: {
  aventurine-cursor = super.callPackage ./aventurine-cursor { };

  hellpaper = super.callPackage ./hellpaper { };

  stray-font = super.callPackage ./stray-font { };

  # from: https://github.com/iynaix/dotfiles/blob/02e3fce049588e0cc2fb3fd5f24b67fe180bd6fb/overlays/nitch-nix-pkgs-count.patch
  nitch = super.nitch.overrideAttrs (o: {
    patches = (o.patches or [ ]) ++ [ ./nitch/nitch-nix-pkgs-count.patch ];
  });

  # FIXME: remove when upstreamed to support awww
  waypaper = super.waypaper.overrideAttrs (oldAttrs: {
    version = "unstable-2026-17f60be";
    src = super.fetchFromGitHub {
      owner = "anufrievroman";
      repo = "waypaper";
      rev = "17f60be4c6abc5ab9c5d4837d930015661ccdd3d";
      hash = "sha256-HkWsffcK/FjXeyzp948xhvMbrdrBcGwkuTI9O16OWbo=";
    };
  });
}
