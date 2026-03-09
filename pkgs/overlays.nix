self: super: {
  aventurine-cursor = super.callPackage ./aventurine-cursor { };

  hellpaper = super.callPackage ./hellpaper { };

  stray-font = super.callPackage ./stray-font { };

  nitch = super.nitch.overrideAttrs (o: {
    # from: https://github.com/iynaix/dotfiles
    patches = (o.patches or [ ]) ++ [ ./nitch/nitch-nix-pkgs-count.patch ];
  });

  linux-wallpaperengine = super.linux-wallpaperengine.overrideAttrs (o: {
    version = "0-unstable-2026-03-01";
    src = super.fetchFromGitHub {
      owner = "Almamu";
      repo = "linux-wallpaperengine";
      rev = "7067d6ff9fd34e36eeccf44e15f86ad604244f26";
      hash = "sha256-NjEcrytgD5KVpB4kS4Cwa2SpxSRL4Tgt2yz6Ygd2p5A=";
      fetchSubmodules = true;
    };
  });
}
