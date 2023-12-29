{ lib, pkgs, ... }: {
  home.username = lib.mkForce "hgh";
  home.homeDirectory = lib.mkForce /home/hgh;
  imports = [ ../hgh/git.nix ];

  # configurable app
  euphgh.home = {
    nvim.enable = true;
    tmux.enable = true;
    zsh.antidote = true;
  };

  # unconfigurable app
  euphgh.home = {
    devCli.enable = true;
    utilCli.enable = true;
  };

  # more unconfigurable app
  home.packages = with pkgs; [
    # util cli
    neofetch
    sshfs
    millw-alias-mill
    jdk17_headless
  ];
}
