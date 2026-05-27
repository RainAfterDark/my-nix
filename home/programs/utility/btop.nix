{ pkgs, ... }:
let
  btop-base = pkgs.btop.override {
    cudaSupport = false;
    rocmSupport = false;
  };

  btop-cuda = pkgs.symlinkJoin {
    name = "btop-cuda";
    paths = [
      (pkgs.btop.override {
        cudaSupport = true;
        rocmSupport = false;
      })
    ];
    postBuild = ''
      mv $out/bin/btop $out/bin/btop-cuda
    '';
  };

  btop-rocm = pkgs.symlinkJoin {
    name = "btop-rocm";
    paths = [
      (pkgs.btop.override {
        cudaSupport = false;
        rocmSupport = true;
      })
    ];
    postBuild = ''
      mv $out/bin/btop $out/bin/btop-rocm
    '';
  };
in
{
  stylix.targets.btop.enable = true;

  home.packages = [
    btop-cuda
    btop-rocm
  ];

  programs.btop = {
    enable = true;
    package = btop-base;
    settings = {
      update_ms = 500;
      rounded_corners = false;
    };
  };
}
