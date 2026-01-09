self: super: {
  aventurine-cursor = super.callPackage ./aventurine-cursor { };

  hellpaper = super.callPackage ./hellpaper { };

  stray-font = super.callPackage ./stray-font { };

  # from: https://github.com/iynaix/dotfiles/blob/02e3fce049588e0cc2fb3fd5f24b67fe180bd6fb/overlays/nitch-nix-pkgs-count.patch
  nitch = super.nitch.overrideAttrs (o: {
    patches = (o.patches or [ ]) ++ [ ./nitch-nix-pkgs-count.patch ];
  });
}
