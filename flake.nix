{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { self, nixpkgs, nur, home-manager, ... }@inputs:
    let
      defaultSysList = [ "aarch64-darwin" "aarch64-linux" "x86_64-darwin" "x86_64-linux" ];
      foreachSysInList = sys: f: nixpkgs.lib.genAttrs (sys) (system:
        let
          p = { nixpkgs = nixpkgs.legacyPackages.${system}; };
        in
        f p);
      devShellsDir = ./devShells;
    in
    {
      homeConfigurations."hgh" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          nur.nixosModules.nur
          self.outputs.nixosModules.euphgh.home
          ./home/hgh
        ];
      };
      nixosConfigurations = {
        sayurin = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            nur.nixosModules.nur
            ./nixos/configurations/configuration.nix
          ];
          specialArgs = { inherit inputs; };
        };
        Rikki = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            self.outputs.nixosModules.euphgh.sys
            ./nixos/configurations/Rikki
          ];
          specialArgs = { inherit inputs; };
        };
      };
      nixosModules.euphgh.sys = import ./nixos/modules;
      nixosModules.euphgh.home = import ./home/modules;
      devShells = foreachSysInList defaultSysList (p: import devShellsDir p);
    };
}
