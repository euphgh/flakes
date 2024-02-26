{ self, lib, pkgs, system, ... }:
let
  mill-alias = self.packages.${system}.millw.override { alias = "mill"; };
in
{
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
    jdk17_headless
    mill-alias
    sbt
  ];
}
