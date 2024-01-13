{ lib
, mkShell
, stdenv
  # other devShell
, riscv-dev
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
, bison
, flex
  # nemu build depandency
, ncurses
, readline
, llvmPackages_15
  # chisel compile
, jdk17_headless
, mill
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
    ncurses
    SDL2
    SDL2_image
    imagemagick # for nslide

    verilator
    readline
    valgrind
    bison
    flex
    llvmPackages_15.libllvm
    jdk17_headless
    mill
  ];
  inputsFrom = [
    riscv-dev
  ];
  NIX_LD_LIBRARY_PATH = lib.makeLibraryPath [
    libgccjit # for iSTA
    libunwind # for iSTA
    stdenv.cc.cc
    zlib
  ];
  NIX_LD = lib.fileContents "${stdenv.cc}/nix-support/dynamic-linker";
  shellHook = ''
    export NIX_CFLAGS_COMPILE="-isystem ${SDL2.dev}/include/SDL2 $NIX_CFLAGS_COMPILE"
  '';
}
