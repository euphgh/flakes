{ ... }: {
  programs.git = {
    enable = true;
    userName = "Guanghui Hu";
    userEmail = "120L052208@stu.hit.edu.cn";
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      core = {
        editor = "nvim";
      };
    };
  };
}
