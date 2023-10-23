{ config, pkgs, ... }:
{
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.home-manager.enable = true;
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  home = {
    username = "hgh";
    homeDirectory = "/home/hgh";
    stateVersion = "23.05";
    packages = with pkgs; [
      config.nur.repos.linyinfeng.wemeet
      cachix
      chromium
      qq
      qbittorrent
      vlc
      plex-media-player
      mpv
      fd
      btop
      ripgrep
      jdk17_headless
      mill
      stdenv.cc
      gdb
      lldb_15
      gnumake
      sshfs
      drawio
      appimage-run
      logseq

      xclip
      flameshot
      neofetch
      trashy
      patchelf
      file
      gtkwave
      python3

      # compress
      p7zip
      rar
      zip
      unzip
      musescore

      bear
      bat
      (pkgs.texlive.combine {
        inherit (pkgs.texlive) scheme-full;
      })
    ];
  };
  imports = (import ./nvim) ++ (import ./tmux) ++ (import ./zsh) ++ [
    ./vscode/default.nix
    ./alacritty/default.nix
  ];
  home.sessionVariables = {
    EDITOR = "nvim";
  };
}