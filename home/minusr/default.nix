{ pkgs, ... }:
{
  # unconfigurable app
  euphgh.home = {
    devCli.enable = true;
  };

  # more unconfigurable app
  home.packages = with pkgs; [
    # util cli
    neofetch
  ];

  home = {
    sessionVariables = {
      EDITOR = "nvim";
    };
  };
}
