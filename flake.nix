{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = inputs: rec {
    utils = (import ./utils) inputs;

    homeConfigurations = utils.creatHome { };
    nixosConfigurations = utils.createNixOS { };

    nixosModules.euphgh.sys = import ./modules/sys;
    nixosModules.euphgh.home = import ./modules/home;

    devShells = with utils; foreachSysInList defaultSysList (p: import devShellsDir p);
  };
}
