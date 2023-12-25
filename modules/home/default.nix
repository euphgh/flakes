{ lib, config, pkgs, ... }@inputs: {
  imports = [
    ./alacritty
    ./kitty
    ./nvim
    ./tmux
    ./vscode
    ./zsh
    ./utilCli.nix
    ./utilGui.nix
    ./devCli.nix
    ./tex.nix
  ];
  options.euphgh.home.specialArgs = with lib; mkOption {
    default = { };
    type = types.attrs;
    example = { username = "hgh"; };
    description = "Argments passed to home-manager config";
  };
  config = {
    xdg.enable = true;
    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;
    programs.home-manager.enable = true;
    nixpkgs.config.allowUnfree = true;
    home = with lib; rec {
      stateVersion = mkDefault inputs.stateVersion;
      username = config.euphgh.home.specialArgs.username;
      homeDirectory = mkDefault "/home/${username}";
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
      packages = with pkgs; [ bat ];
    };
  };
}

