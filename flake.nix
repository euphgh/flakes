{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { self, nixpkgs, nur, home-manager, ... }@inputs:
    let
      lib = nixpkgs.lib;
      defaultParamSet = {
        system = "x86_64-linux";
        stateVersion = "23.05";
      } // inputs;
      # makeHome =
      #   { unixname
      #   , system
      #   , stateVersion
      #   }:
      #   {
      #     ${unixname} = home-manager.lib.homeManagerConfiguration {
      #       pkgs = nixpkgs.legacyPackages.${system};
      #       modules = [
      #         nur.nixosModules.nur
      #         self.outputs.nixosModules.euphgh.home
      #         (./home + "/${unixname}")
      #       ];
      #       extraSpecialArgs = { inherit paramSet; };
      #     };
      #   };

    in
    rec {
      utils = (import ./utils) inputs;
      inherit defaultParamSet;

      # homeConfigurations = { }
      #   // makeHome { unixname = "hgh"; }
      #   // makeHome { unixname = "foo"; };

      nixosConfigurations = utils.createNixOS {
        xxpro13 = defaultParamSet;
        minvm = defaultParamSet;
      };

      nixosModules.euphgh.sys = import ./modules/sys;
      nixosModules.euphgh.home = import ./modules/home;

      devShells = with utils; foreachSysInList defaultSysList (p: import devShellsDir p);
    };
}
