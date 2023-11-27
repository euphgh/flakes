{ lib
, mkShell
, stdenv
  # other devShell
, cpp-dev
, python-dev
, riscv-cross
  # hardware tools
, verilator
  # advance c tools and libs
, valgrind
  # navy build depandency
, SDL
, SDL_image
  # nemu device build depandency
, SDL2
, SDL2_image
  # nslide depandency
, imagemagick
  # nemu menuconfig build depandency
, ncurses
, bison
, flex
  # nemu build depandency
, readline
, llvmPackages_15
  # iSTA runtime depancency
, libgccjit # for iSTA
, libunwind # for iSTA
, zlib
}:
mkShell {
  packages = [
    # for navy flip bird app
    SDL
    SDL_image
    # for nemu run
    SDL2
    SDL2_image
    imagemagick # for nslide

    verilator
    readline
    valgrind
    ncurses
    bison
    flex
    llvmPackages_15.libllvm
  ];
  inputsFrom = [
    cpp-dev
    riscv-cross
    python-dev
  ];
  NIX_LD_LIBRARY_PATH = lib.makeLibraryPath [
    libgccjit # for iSTA
    libunwind # for iSTA
    stdenv.cc.cc
    zlib
    ncurses
  ];
  NIX_LD = lib.fileContents "${stdenv.cc}/nix-support/dynamic-linker";
  shellHook = ''
    export YSYX_HOME=/home/hgh/ysyx-workbench

    export NEMU_HOME=$YSYX_HOME/nemu
    export NIX_CFLAGS_COMPILE="-isystem ${SDL2.dev}/include/SDL2 $NIX_CFLAGS_COMPILE"

    export NPC_HOME=$YSYX_HOME/npc

    # for abstract-machine
    export AM_HOME=$YSYX_HOME/abstract-machine
    export ARCH=riscv64-nemu

    # for navy-apps
    export NAVY_HOME=$YSYX_HOME/navy-apps
    export ISA=riscv64

    export NVBOARD_HOME=$YSYX_HOME/nvboard
  '';
}
