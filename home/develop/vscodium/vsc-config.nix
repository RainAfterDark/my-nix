{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium.overrideAttrs (old: {
      # Remove annoying warnings
      postFixup = (old.postFixup or "") + ''
        echo "Patching codium launcher to remove auto Wayland flags..."
        sed -i \
          -e 's/--ozone-platform-hint=auto//g' \
          -e 's/--enable-features=WaylandWindowDecorations//g' \
          -e 's/--enable-wayland-ime=true//g' \
          -e 's/--wayland-text-input-version=3//g' \
          $out/bin/codium
      '';
    });
  };
}
