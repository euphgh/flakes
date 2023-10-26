{ pkgs, lib, ... }: {
  environment.systemPackages = with pkgs; [
    # basic dev tools
    stdenv.cc
    gnumake
    python3

    # get resource from web
    wget
    curl
    git

    # help page
    man-pages
    man-pages-posix
  ];
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };
  system.stateVersion = lib.mkDefault "23.11";
}
