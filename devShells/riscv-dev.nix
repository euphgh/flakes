{ riscv-cross # must be assign
, cpp-dev # must be assign
, mkShell
, dtc
, bc
, ncurses
}:
mkShell {
  packages = [
    dtc # for spike compile
    bc # for Linux kernel build
    ncurses # for menuconfig
  ];
  inputsFrom = [
    riscv-cross
    cpp-dev
  ];
  shellHook = ''
    export ARCH=riscv
  '';
}
