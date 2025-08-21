{ lib, pkgs, ... }:
let
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
              "clientToken": "0",
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
  home.packages = with pkgs; [ prismlauncher ];
  # We do a little sneaky
  home.activation.createPrismLauncherAccounts = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    accounts_file="''${XDG_DATA_HOME:-''$HOME/.local/share}/PrismLauncher/accounts.json"
    if [ ! -e "$accounts_file" ]; then
      mkdir -p "$(dirname "$accounts_file")"
      json='${accountJson}'
      echo "$json" > "$accounts_file"
    fi
  '';
}
