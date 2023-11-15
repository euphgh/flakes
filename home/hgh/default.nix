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

    #gui tools
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
      EDITOR = "code";
    };
  };
}
