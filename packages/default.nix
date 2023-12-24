{ nixpkgs ? import <nixpkgs> { }, ... }@inputs: {
  millw = nixpkgs.callPackage ./millw.nix { };
}
