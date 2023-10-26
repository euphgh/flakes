{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    home-manager.url = "github:nix-community/home-manager";
  };

  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [
      # replace official cache with a mirror located in China
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://cache.nixos.org/"
    ];
  };

  outputs = { self, nixpkgs, nur, home-manager, ... }@inputs:
    let
      defaultSys = [ "aarch64-darwin" "aarch64-linux" "x86_64-darwin" "x86_64-linux" ];
      foreachSys = sys: f: nixpkgs.lib.genAttrs (sys) (system:
        let
          p = {
            nixpkgs = nixpkgs.legacyPackages.${system};
          };
        in
        f p);
      devShellsDir = ./devShells;
      packagesDir = ./pkgs;
    in
    {
      homeConfigurations."hgh" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        les = [
          nur.nixosModules.nur
          "./home/home.nix"
        ];
      };
      nixosConfigurations = {
        sayurin = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            nur.nixosModules.nur
            ./nixos/configurations/configuration.nix
          ];
        };
        Rikki = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            self.outputs.nixosModules.euphgh
            ./nixos/configurations/Rikki
          ];
          specialArgs = { inherit inputs; };
        };
      };
      nixosModules.euphgh = import ./nixos/modules;
      devShells = foreachSys defaultSys (p: import devShellsDir p);
    };
}
