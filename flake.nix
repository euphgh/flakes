{
  description = "euphgh create flake, including system, home, modules, templates, devShells";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: rec {
    utils = (import ./utils) inputs;

    homeConfigurations = utils.createHome { };
    nixosConfigurations = utils.createNixOS { };

    nixosModules.euphgh.sys = import ./modules/sys;
    nixosModules.euphgh.home = import ./modules/home;

    devShells = with utils; foreachSysInList defaultSysList (p: import devShellsDir p);

    templates = rec {
      shell = {
        path = ./templates/devShell;
        description = "flake with only devShells using euphgh";
        welcomeText = "welcome to use euphgh's devShells flake template !!!!!";
      };
      default = shell;
    };
  };
}
