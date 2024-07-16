{ config, pkgs, stateVersion, hostname, system, ... }@inputs: {
  imports = [
    ./clash
    ./clash/rule.nix
    ./bluetooth.nix
    ./nix.nix
    ./gui.nix
    ./user.nix
    ./sops.nix
    ./docker.nix
    ./nix-ld.nix
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
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

    # password
    pass
    age
    ssh-to-age
  ];

  services.pcscd.enable = true;
  programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
  };

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
    allowedTCPPorts = [ 22 8899 ]; 
  };

  #home-manaager system level config
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.sharedModules = with inputs; [
    nur.nixosModules.nur
    self.outputs.nixosModules.euphgh.home
  ];
  home-manager.extraSpecialArgs = builtins.removeAttrs inputs [ "pkgs" "config" "options" "lib" ];
  environment.pathsToLink = [ "/share/zsh" ];
}
