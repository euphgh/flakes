{ pkgs, stateVersion, hostname, ... }: {
  imports = [
    ./nurClash.nix
    ./bluetooth.nix
    ./nix.nix
    ./gui.nix
    ./user.nix
  ];
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

    #editor
    neovim
    sops

    # nix repo
    cachix
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
  programs.git.enable = true;
  system.stateVersion = stateVersion;

  networking.hostName = hostname;
  networking.firewall = {
    enable = true;
  };
}
