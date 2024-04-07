{ nixpkgs ? import <nixpkgs> { }, ... }: {
  mill = nixpkgs.callPackage ./millw.nix { };
  verilator = nixpkgs.callPackage ./verilator.nix { };
  bloop = nixpkgs.callPackage ./bloop.nix { };
  fcitx5-pinyin-zhwiki = nixpkgs.callPackage ./fcitx5-pinyin-zhwiki.nix { };
}
