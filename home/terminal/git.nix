{ pkgs, username, ... }:
{
  home.packages = with pkgs; [
    gh
    git-lfs
    git-filter-repo
  ];

  xdg.configFile."git/.gitignore".text = ''
    .vscode
  '';

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Ame";
        email = "rainafterd4rk@gmail.com";
      };
      init.defaultBranch = "main";
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
      pull.ff = "only";
      color.ui = true;
      url = {
        "git@github.com:".insteadOf = [
          "gh:"
          "https://github.com/"
        ];
        "git@github.com:RainAfterDark/".insteadOf = "fp:";
      };
      core.excludesFile = "/home/${username}/.config/git/.gitignore";
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      line-numbers = true;
      side-by-side = false;
      diff-so-fancy = true;
      navigate = true;
    };
  };

  stylix.targets.lazygit.enable = true;

  programs.lazygit = {
    enable = true;
    settings = {
      gui.border = "single";
    };
  };
}
