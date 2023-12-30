{ nixpkgs ? import <nixpkgs> { }, ... }@inputs: {
  millw = nixpkgs.callPackage ./millw.nix { };
  verilator_5016 = nixpkgs.callPackage ./verilator_5016.nix { };
}
