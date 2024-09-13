{ ... }: {
  programs.git = {
    enable = true;
    userName = "Guanghui Hu";
    userEmail = "hugh2024@shanghaitech.edu.cn";
    ignores = [
      "*~"
      "*.swp"
      ".direnv/"
      ".cache/"
      ".vscode/"
    ];
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      core = {
        editor = "nvim";
      };
    };
    aliases = {
      st = "status -sb";
      cm = "commit -m";
      rv = "remote -v";
      last = "log -1 HEAD --stat";
      d = "diff";
      gl = "config --global -l";
      se = "!git rev-list --all | xargs git grep -F";
      rt = "!cd $(git rev-parse --show-toplevel)"; #root
      co = "checkout";
      ll = "log --oneline";
      ig = "!echo \"$@\" >> .git/info/exclude";
    };
  };
}
