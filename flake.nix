{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    home-manager.url = "github:nix-community/home-manager";
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
    in
    {
      homeConfigurations."hgh" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        les = [
          nur.nixosModules.nur
          "./home/home.nix"
        ];
      };
      nixosConfigurations."sayurin" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nur.nixosModules.nur
          ./nixos/configurations/configuration.nix
        ];
      };

      devShells = foreachSys defaultSys (p: import devShellsDir p);
    };
}
