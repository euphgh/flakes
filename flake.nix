{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    home-manager.url = "github:nix-community/home-manager";
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = inputs: rec {
    utils = (import ./utils) inputs;

    homeConfigurations = utils.createHome { };
    nixosConfigurations = utils.createNixOS { };

    nixosModules.euphgh.sys = import ./modules/sys;
    nixosModules.euphgh.home = import ./modules/home;

    devShells = with utils; foreachSysInList defaultSysList (p: import devShellsDir p);
  };
}
