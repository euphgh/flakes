{ pkgs, self, system, lib, ... }:
let
  millw-alias-mill = self.packages.${system}.millw.override {
    alias = "mill";
  };
in
{
  imports = [ ./git.nix ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = pkgs.lib.optional (pkgs.obsidian.version == "1.5.3") "electron-25.9.0";
    };
  };

  # configurable app
  euphgh.home = {
    nvim.enable = true;
    tmux.enable = true;
    zsh.antidote = true;
    vscode.enable = true;
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
    millw-alias-mill
    jdk17_headless

    #gui tools
    gtkwave
    logseq
    obsidian
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
