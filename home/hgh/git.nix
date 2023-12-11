{ ... }: {
  programs.git = {
    enable = true;
    userName = "Guanghui Hu";
    userEmail = "120L052208@stu.hit.edu.cn";
    ignores = [
      "*~"
      "*.swp"
      ".direnv/"
      ".cache/"
      ".envrc"
    ];
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      core = {
        editor = "nvim";
      };
    };
    alias = {
      st = "status -sb";
      cm = "commit -m";
      rv = "remote -v";
      last = "log -1 HEAD --stat";
      d = "diff";
      gl = "config --global -l";
      se = "!git rev-list --all | xargs git grep -F";
      co = "checkout";
      ll = "log --oneline";
    };
  };
}
