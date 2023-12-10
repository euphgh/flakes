{ lib, config, ... }@inputs: {
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
    };
  };
}

