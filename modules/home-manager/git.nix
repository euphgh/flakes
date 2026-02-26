{ ... }: {
  programs.git = {
    enable = true;
    ignores = [
      "*~"
      "*.swp"
      ".direnv/"
      ".cache/"
      ".vscode/"
    ];
    settings = {
      user = {
        name = "Guanghui Hu";
        email = "hugh2024@shanghaitech.edu.cn";
      };
      init = {
        defaultBranch = "main";
      };
      core = {
        editor = "nvim";
      };
      alias = {
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
  };
}
