{ lib, pkgs, ... }:
let
  prismlauncher =
    (import (fetchGit {
      name = "prismlauncher-9.4";
      url = "https://github.com/NixOS/nixpkgs/";
      ref = "refs/heads/nixpkgs-unstable";
      rev = "e6f23dc08d3624daab7094b701aa3954923c6bbb";
      shallow = true;
    }) { inherit (pkgs.stdenv.hostPlatform) system; }).prismlauncher.override
      {
        jdks = with pkgs; [
          jdk25
          jdk21
          jdk17
          jdk8
        ];
      };

  accountJson = ''
    {
      "accounts": [
        {
          "active": true,
          "entitlement": {
            "canPlayMinecraft": true,
            "ownsMinecraft": true
          },
          "profile": {
            "capes": [
            ],
            "id": "0",
            "name": "",
            "skin": {
              "id": "",
              "url": "",
              "variant": ""
            }
          },
          "type": "MSA",
          "ygg": {
            "extra": {
              # "clientToken": "0",
              "userName": ""
            },
            "iat": 0,
            "token": "0"
          }
        }
      ],
      "formatVersion": 3
    }
  '';
in
{
  home.packages = [ prismlauncher ];

  # We do a little sneaky
  home.activation.createPrismLauncherAccounts =
    lib.hm.dag.entryAfter [ "writeBoundary" ]
      ''
        accounts_file="''${XDG_DATA_HOME:-''$HOME/.local/share}/PrismLauncher/accounts.json"
        if [ ! -e "$accounts_file" ]; then
          mkdir -p "$(dirname "$accounts_file")"
          json='${accountJson}'
          echo "$json" > "$accounts_file"
        fi
      '';
}
