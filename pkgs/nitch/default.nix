{ nitch, ... }:
nitch.overrideAttrs (o: {
  # from: https://github.com/iynaix/dotfiles
  patches = (o.patches or [ ]) ++ [ ./nitch-nix-pkgs-count.patch ];
})
