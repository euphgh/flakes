{ lib, config, pkgs, ... }@inputs: {
  imports = [
    ./nvim
    ./tmux
    ./vscode
    ./zsh
    ./git.nix
    ./utilCli.nix
    ./utilGui.nix
    ./devCli.nix
    ./tex.nix
  ];
  options.euphgh.home.enable = with lib; mkEnableOption "Enable the home-manager configuration";
  config = lib.mkIf config.euphgh.home.enable {
    xdg.enable = true;
    programs.direnv.enable = true;
    programs.home-manager.enable = true;
    home = {
      shellAliases = {
        ls = "ls --color -h";
        ll = "ls -alF ";
        la = "ls -A ";
        l = "ls -CF ";
        mj = "make -j \$(nproc)";
        tp = "trash put";
        ip = "ip --color=auto";
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        grep = "grep --color=auto";
        cat = "bat --paging=never";
      };
    };
  };
}

