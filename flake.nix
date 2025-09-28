{
  description = "A Nix flake with modules for NixOS and Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, home-manager }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        # Development shell
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            nixfmt-rfc-style
            direnv
          ];
        };

        # Packages that can be built
        packages = {
          # Example package - you can add your own here
          hello = pkgs.hello;
        };
      }
    ) // {
      # Standalone Home Manager configurations
      homeConfigurations = {
        "hgh@m4" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-darwin;
          modules = [
            (./home-manager + "/hgh@m4.nix")
            ./modules/home-manager
          ];
          extraSpecialArgs = { inherit self; };
        };
        "hgh@265k" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [
            (./home-manager + "/hgh@265k.nix")
            ./modules/home-manager
          ];
          extraSpecialArgs = { inherit self; };
        };
      };

      # Custom modules
      nixosModules.euphgh.home = import ./modules/home-manager;
    };
}
