{ nixpkgs ? import <nixpkgs> { }, ... }@inputs: {
  millw = nixpkgs.callPackage ./millw.nix { };
  verilator_5016 = nixpkgs.callPackage ./verilator_5016.nix { };
  verilator_4218 = nixpkgs.callPackage ./verilator_4218.nix { };
  fcitx5-pinyin-zhwiki = nixpkgs.callPackage ./fcitx5-pinyin-zhwiki.nix { };
}
