{ config, pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      l = "eza --icons -a --group-directories-first -1";
      ll = "eza --icons -a --group-directories-first -1 --no-user --long";
      tree = "eza --icons --tree --group-directories-first";
    };

    plugins = [
      {
        name = "fzf-tab";
        src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
      }
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = "${pkgs.zsh-nix-shell}/share/zsh-nix-shell";
      }
    ];

    completionInit =
      let
        cachePath = "${config.xdg.cacheHome or "${pkgs.lib.getEnv "HOME"}/.cache"}/zsh";
      in
      ''
        autoload -U colors && colors
        autoload -U compinit && compinit -u
        _comp_options+=(globdots)

        # completion cache
        zstyle ':completion:*' use-cache on
        zstyle ':completion:*' cache-path "${cachePath}/.zcompcache"

        # fzf-tab config
        zstyle ':fzf-tab:*' fzf-command fzf
        zstyle ':fzf-tab:*' use-fzf-default-opts yes
        zstyle ':fzf-tab:complete:*:*' fzf-preview '[[ -d $realpath ]] && eza --tree --color=always $realpath | head -200 || bat -n --color=always --line-range :200 $realpath'
        zstyle ':fzf-tab:*' fzf-pad 4
      '';

    initContent = ''
      # history behaviour
      setopt sharehistory
      setopt hist_ignore_space
      setopt hist_ignore_all_dups
      setopt hist_save_no_dups
      setopt hist_ignore_dups
      setopt hist_find_no_dups
      setopt hist_expire_dups_first
      setopt hist_verify

      # prefer emacs-like keys
      bindkey -e

      # handy fuzzy history search with up/down
      autoload -U up-line-or-beginning-search down-line-or-beginning-search
      zle -N up-line-or-beginning-search
      zle -N down-line-or-beginning-search
      bindkey '^[[A' up-line-or-beginning-search
      bindkey '^[[B' down-line-or-beginning-search

      # cheatsheet widget (bound to Ctrl+G)
      eval "$(navi widget zsh)"

      # system info
      pfetch
    '';
  };

  stylix.targets.fzf.enable = true;
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;

    defaultCommand = "fd --hidden --strip-cwd-prefix --exclude .git";
    fileWidgetOptions = [
      "--preview 'if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi'"
    ];
    changeDirWidgetCommand = "fd --type=d --hidden --strip-cwd-prefix --exclude .git";
    changeDirWidgetOptions = [
      "--preview 'eza --tree --color=always {} | head -200'"
    ];

    defaultOptions = [
      "--border='double' --border-label='' --preview-window='border-sharp' --prompt='> '"
      "--marker='>' --pointer='>' --separator='─' --scrollbar='│'"
      "--info='right'"
      "--bind change:top"
    ];
  };

  stylix.targets.starship.enable = true;
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}
