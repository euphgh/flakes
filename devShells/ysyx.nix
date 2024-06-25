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
, readline
, llvmPackages
  # chisel compile
, jdk17_headless
, mill
, bloop
  # iSTA runtime depancency
, libgccjit # for iSTA
, libunwind # for iSTA
, zlib
, python-dev
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
    bison
    flex
    llvmPackages.libllvm
    jdk17_headless
    mill
    # bloop
  ];
  inputsFrom = [
    riscv-dev
    python-dev
  ];
  NIX_LD_LIBRARY_PATH = lib.makeLibraryPath [
    libgccjit # for iSTA
    libunwind # for iSTA
    zlib
  ];
  NIX_LD = lib.fileContents "${stdenv.cc}/nix-support/dynamic-linker";
  shellHook = ''
    export NIX_CFLAGS_COMPILE="-isystem ${SDL2.dev}/include/SDL2 $NIX_CFLAGS_COMPILE"
  '';
}
