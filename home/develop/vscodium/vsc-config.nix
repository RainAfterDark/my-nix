{ pkgs, ... }: {
  stylix.targets.vscodium.enable = true;
  programs.vscodium = {
    enable = true;
    package =
      let
        codeExe = "codium";
      in
      pkgs.vscodium.overrideAttrs (old: {
        # Remove annoying warnings
        postFixup = (old.postFixup or "") + ''
          # bash
          echo "Patching launcher to remove auto Wayland flags..."
          sed -i \
            -e 's/--ozone-platform-hint=auto//g' \
            -e 's/--enable-features=WaylandWindowDecorations//g' \
            -e 's/--enable-wayland-ime=true//g' \
            -e 's/--wayland-text-input-version=3//g' \
            $out/bin/${codeExe}
        '';
      });
  };
}
