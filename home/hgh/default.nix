{ config, pkgs, ... }:
{
  imports = [ ./git.nix ];

  # configurable app
  euphgh.home = {
    nvim.enable = true;
    tmux.enable = true;
    zsh.enable = true;
    vscode.enable = true;
    alacritty.enable = true;
    kitty.enable = false;
    tex.enable = true;
  };

  # unconfigurable app
  euphgh.home = {
    devCli.enable = true;
    utilCli.enable = true;
    utilGui.enable = true;
  };

  # more unconfigurable app
  home.packages = with pkgs; [
    # util cli
    neofetch
    sshfs
    mill
    jdk17_headless

    #gui tools
    kitty
    gtkwave
    logseq
    drawio
    musescore

    # vedio
    qbittorrent
    vlc
  ];

  home = {
    sessionVariables = {
      EDITOR = "nvim";
    };
  };
}
