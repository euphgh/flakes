{ nixpkgs, ... }@inputs:
rec {
  # without 3rd python packages
  python-dev = nixpkgs.callPackage ./basic/python.nix {
    # you can add more python packages like this
    # pyPkgs = ps: with ps; [ numpy ];
  };

  riscv-cross = nixpkgs.callPackage ./basic/riscv-cross.nix { };
  cpp-dev = nixpkgs.callPackage ./basic/cpp.nix { };

  # this is a combine show
  riscv-dev = nixpkgs.mkShell {
    packages = with nixpkgs; [
      dtc # for spike compile
      bc # for Linux kernel build
      ncurses # for menuconfig
    ];
    inputsFrom = [ riscv-cross ];
    shellHook = '' export ARCH=riscv '';
  };
  ysyx = nixpkgs.callPackage ./ysyx.nix { inherit cpp-dev riscv-cross; };
  self-dev =
    let
      pyWithPacks = python-dev.override {
        pyPkgs = (ps: with ps; [
          xdg
          (
            buildPythonPackage {
              pname = "impurity";
              version = "0.0.1";
              src = ./python-impurity;
              doCheck = false;
              propagatedBuildInputs = [
                # Specify dependencies
              ];
            }
          )
        ]);
      };
    in
    nixpkgs.mkShell {
      packages = with nixpkgs; [
        nixd
      ];
      inputsFrom = [ pyWithPacks ];
    };
}
