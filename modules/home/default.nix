{ ... }@inputs: {
  imports = [
    ./alacritty
    ./nvim
    ./tmux
    ./vscode
    ./zsh
    ./utilCli.nix
    ./utilGui.nix
    ./devCli.nix
    ./tex.nix
  ];
  config = {
    xdg.enable = true;
    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;
    programs.home-manager.enable = true;
    home = {
      stateVersion = inputs.stateVersion;
      username = inputs.unixname;
      homeDirectory = "/home/${inputs.unixname}";
    };
  };
}

