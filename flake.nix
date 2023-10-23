{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs = { self, nixpkgs, ... }@inputs:
    let
      defaultSys = [ "aarch64-darwin" "aarch64-linux" "x86_64-darwin" "x86_64-linux" ];
      foreachSys = sys: f: nixpkgs.lib.genAttrs (sys) (system:
        let p = { nixpkgs = nixpkgs.legacyPackages.${system}; }; in
        f p
      );
    in
    {
      packages = foreachSys defaultSys (p: {
        hello = p.nixpkgs.hello;
      });

      devShells = foreachSys defaultSys (p: import ./devShell p);
    };
}
