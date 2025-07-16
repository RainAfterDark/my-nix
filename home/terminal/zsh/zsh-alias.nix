{
  host,
  flakeRoot,
  ...
}:
{
  programs.zsh = {
    shellAliases = {
      ## Utils
      c = "clear";
      cd = "z";
      tt = "gtrash put";
      cat = "bat";
      code = "codium";
      diff = "delta --diff-so-fancy --side-by-side";
      less = "bat";
      icat = "kitten icat";
      size = "du -hs";
      open = "xdg-open";

      l = "eza --icons  -a --group-directories-first -1"; # EZA_ICON_SPACING=2
      ll = "eza --icons  -a --group-directories-first -1 --no-user --long";
      tree = "eza --icons --tree --group-directories-first";

      ## Nixos
      cx = "cd ${flakeRoot} && codium ${flakeRoot}";
      nz = "nom-shell --run zsh";
      nd = "nom develop --command zsh";
      nb = "nom build";
      ns = "nh search";
      nc = "notifywrap 'nh clean all --keep 5 && nix-store --optimise' '🧹 Nix Store Clean'";
      not = "notifywrap 'sudo nh os test -H ${host} -R ${flakeRoot} --no-reexec --offline' '❄️ NixOS Test'";
      nob = "notifywrap 'sudo nh os boot -H ${host} -R ${flakeRoot}' '❄️ NixOS Boot'";
      nos = "notifywrap 'sudo nh os switch -H ${host} -R ${flakeRoot}' '❄️ NixOS Switch'";
    };
  };
}
