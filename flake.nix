{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { self, nixpkgs, nur, home-manager, ... }@inputs:
    let
      releaseVersion = "23.11";
      defaultSysList = [ "aarch64-darwin" "aarch64-linux" "x86_64-darwin" "x86_64-linux" ];
      foreachSysInList = sys: f: nixpkgs.lib.genAttrs (sys) (system:
        let
          p = { nixpkgs = nixpkgs.legacyPackages.${system}; };
        in
        f p);
      devShellsDir = ./devShells;
      makeHome =
        { unixname ? "hgh"
        , system ? "x86_64-linux"
        , stateVersion ? releaseVersion
        }:
        {
          ${unixname} = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.${system};
            modules = [
              nur.nixosModules.nur
              self.outputs.nixosModules.euphgh.home
              (./home + "/${unixname}")
            ];
            extraSpecialArgs = { inherit stateVersion inputs unixname system; };
          };
        };
      makeNixOS =
        { hostname
        , system ? "x86_64-linux"
        , stateVersion ? releaseVersion
        , addtionalModule ? [ ]
        }:
        {
          ${hostname} = nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              nur.nixosModules.nur
              self.outputs.nixosModules.euphgh.sys
              (./nixos + "/${hostname}")
            ] ++ addtionalModule;
            specialArgs = { inherit stateVersion inputs hostname system; };
          };
        };
    in
    {
      homeConfigurations = { }
        // makeHome { unixname = "hgh"; }
        // makeHome { unixname = "foo"; };

      nixosConfigurations = { }
        // makeNixOS { hostname = "xxpro13"; }
        // makeNixOS { hostname = "minvm"; };

      nixosModules.euphgh.sys = import ./modules/sys;
      nixosModules.euphgh.home = import ./modules/home;
      devShells = foreachSysInList defaultSysList (p: import devShellsDir p);

      utils = import ./utils { lib = nixpkgs.lib; } // {
        inherit makeHome;
      };
    };
}
