{ pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should manage.
  home = {
    username = "hgh";
    homeDirectory = "/Users/hgh";
    stateVersion = "24.11";
  };

  # Enable our custom home manager modules
  euphgh.home = {
    enable = true;
    zsh.antidote = true;
    devCli.enable = true;
    utilCli.enable = true;
  };

  # Additional packages for this user
  home.packages = with pkgs; [
    xcbuild
    qbittorrent
    browserpass
    zotero
  ];
}
