{ mkShell
, pkgsCross
}:
mkShell {
  packages = [
    pkgsCross.riscv64.pkgsStatic.stdenv.cc
    pkgsCross.riscv64.stdenv.cc
    pkgsCross.riscv64-embedded.stdenv.cc
    pkgsCross.riscv64-embedded.riscv-pk # must use riscv64-embedded, not riscv64
  ];
}
