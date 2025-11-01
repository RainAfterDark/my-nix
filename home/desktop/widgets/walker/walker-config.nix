{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [ inputs.walker.homeManagerModules.default ];
  home.packages = with pkgs; [
    libqalculate # for calc module
    wtype # for clipboard and emoji modules
    imagemagick # for image previews
  ];

  # TODO: Update this if elephant's nix module decides to be sane
  xdg.configFile =
    let
      toToml = name: value: (pkgs.formats.toml { }).generate "${name}.toml" value;
      mkProviderCfg =
        providers: value:
        builtins.listToAttrs (
          map (
            provider:
            lib.nameValuePair "elephant/${provider}.toml" {
              source = toToml provider value;
            }
          ) providers
        );
    in
    mkProviderCfg [
      "clipboard"
      "symbols"
      "unicode"
    ] { command = "wl-copy && wtype -M ctrl -M shift v"; }
    // mkProviderCfg [ "desktopapplications" ] {
      wm_integration = true;
    };

  programs.walker = {
    enable = true;
    runAsService = true;
    config = {
      theme = "stylix";
    };
  };
}
