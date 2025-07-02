{
  pkgs,
  username,
  flakeRoot,
  ...
}:
{
  home.packages = [
    (pkgs.writeShellScriptBin "nfb" ''
      #!/usr/bin/env bash
      set -e

      if [[ -z "$1" ]]; then
        echo "Usage: nfb <host> [extra nix-fast-build flags]" >&2
        exit 1
      fi

      start=$(date +%s)

      host="$1"; shift
      cd "${flakeRoot}"

      rm -f ./result*

      echo "➡️ Building NixOS config for ${username}@''${host}…"

      nix-fast-build \
        --flake ".#nixosConfigurations.''${host}.config.system.build.toplevel" \
        --option sandbox "false" \
        --option auto-optimise-store "false" \
        --option allowed-users "${username}" \
        --option trusted-users "${username}" \
        --option extra-experimental-features "nix-command flakes" \
        --option extra-substituters "https://chaotic-nyx.cachix.org/" \
        --option extra-trusted-public-keys "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8=" \
        --skip-cached \
        --eval-workers 1 \
        --eval-max-memory-size 8192 \
        "$@"

      echo "✅ Build finished, switching…"
      sudo ./result-/bin/switch-to-configuration switch

      end=$(date +%s)
      elapsed=$(( end - start ))

      printf "⏱ Done in %02dm%02ds\n" $((elapsed / 60)) $((elapsed % 60))
    '')
  ];
}
