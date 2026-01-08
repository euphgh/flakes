{ pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should manage.
  home = {
    username = "hgh";
    homeDirectory = "/home/hgh";
    stateVersion = "24.11";
  };

  # Enable our custom home manager modules
  euphgh.home = {
    enable = true;
    zsh.antidote = true;
    devCli.enable = true;
    utilCli.enable = true;
    tex.enable = true;
  };
  home.packages = with pkgs; [
    browserpass
    graphviz
    doxygen
    pandoc
    perl
  ];
}
