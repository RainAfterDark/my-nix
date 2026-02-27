{
  inputs,
  pkgs,
  flakeRoot,
  ...
}:
let
  vicinae-extensions =
    inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  services.vicinae = {
    extensions = with vicinae-extensions; [
      awww-switcher
      bluetooth
      wifi-commander
    ];

    settings = {
      # name HAS to be @<author>/vicinae-extension-<name>-0
      # refer to ~/.local/share/vicinae/extensions (package.json)
      providers = {
        "@sovereign/vicinae-extension-awww-switcher-0" = {
          preferences = {
            wallpaperPath = "${flakeRoot}/assets/gif";
          };
        };
      };
    };
  };
}
