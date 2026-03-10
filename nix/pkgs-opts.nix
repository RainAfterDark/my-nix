{ lib, self, ... }:
let
  insecurePkgs = [ "ventoy-gtk3" ];
  pkgPred = list: (pkg: builtins.elem (lib.getName pkg) list);
in
{
  overlays = [ self.overlays.default ];
  config = {
    allowUnfree = true;
    nvidia.acceptLicense = true;
    android_sdk.accept_license = true;
    allowInsecurePredicate = pkgPred insecurePkgs;
  };
}
