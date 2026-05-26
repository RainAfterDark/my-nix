{ pkgs, ... }:
{
  # TODO: Use vscodium again once theming is supported by stylix for vs forks
  stylix.targets.vscode.enable = true;
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.overrideAttrs (old: {
      # Remove annoying warnings
      postFixup = (old.postFixup or "") + ''
        # bash
        echo "Patching launcher to remove auto Wayland flags..."
        sed -i \
          -e 's/--ozone-platform-hint=auto//g' \
          -e 's/--enable-features=WaylandWindowDecorations//g' \
          -e 's/--enable-wayland-ime=true//g' \
          -e 's/--wayland-text-input-version=3//g' \
          $out/bin/code
      '';
    });
  };
}
