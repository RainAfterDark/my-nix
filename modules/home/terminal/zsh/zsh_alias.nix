{ host, ... }:
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
      f = "superfile";
      py = "python";
      ipy = "ipython";
      icat = "kitten icat";
      dsize = "du -hs";
      pdf = "tdf";
      open = "xdg-open";
      space = "ncdu";

      l = "eza --icons  -a --group-directories-first -1"; # EZA_ICON_SPACING=2
      ll = "eza --icons  -a --group-directories-first -1 --no-user --long";
      tree = "eza --icons --tree --group-directories-first";

      ## Nixos
      myx = "cd ~/my-nix && codium ~/my-nix";
      nos = "nom-shell --run zsh";
      nod = "nom develop --command zsh";
      nob = "nom build";
      nhc = "nh clean all --keep 5";
      nht = "nh os test -H ${host}";
      nhb = "nh os boot -H ${host}";
      nhs = "nh os switch -H ${host}";
      nhp = "nh search";

      ## Shutdown
      off = "poweroff --no-wall";
      rbt = "reboot --no-wall";
    };
  };
}
