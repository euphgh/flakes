{ python-dev # must be assign
, riscv-cross # must be assign
, cpp-dev # must be assign
, mkShell
, dtc
, bc
, ncurses
}:
let
  pyWithPacks = python-dev.override {
    pyPkgs = (ps: with ps; [ pyyaml ]);
  };
in
mkShell {
  packages = [
    dtc # for spike compile
    bc # for Linux kernel build
    ncurses # for menuconfig
  ];
  inputsFrom = [
    riscv-cross
    cpp-dev
    pyWithPacks
  ];
  shellHook = ''
    export ARCH=riscv
  '';
}
