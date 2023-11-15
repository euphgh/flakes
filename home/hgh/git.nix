{ ... }: {
  programs.git = {
    enable = true;
    config = {
      init = {
        defaultBranch = "main";
      };
      user = {
        name = "Guanghui Hu";
        email = "120L052208@stu.hit.edu.cn";
      };
      core = {
        editor = "nvim";
      };
    };
  };
}
