{ config, pkgs, stateVersion, hostname, inputs, system, ... }: {
  imports = [
    ./nurClash.nix
    ./bluetooth.nix
    ./nix.nix
    ./gui.nix
    ./user.nix
    inputs.home-manager.nixosModules.home-manager
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

    # more config
    cachix
    home-manager
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

  #home-manaager system level config
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = { inherit stateVersion inputs system; };
  home-manager.sharedModules = [
    inputs.nur.nixosModules.nur
    inputs.self.outputs.nixosModules.euphgh.home
  ];
}
