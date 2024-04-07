{ nixpkgs, self, system, ... }:
let
  packages = self.packages.${system};
in
rec{
  # without 3rd python packages
  python-dev = nixpkgs.callPackage ./basic/python.nix {
    # you can add more python packages like this
    pyPkgs = ps: with ps; [ numpy ];
  };

  riscv-cross = nixpkgs.callPackage ./basic/riscv-cross.nix { };
  cpp-dev = nixpkgs.callPackage ./basic/cpp.nix { };

  # this is a combine show
  riscv-dev = nixpkgs.callPackage ./riscv-dev.nix {
    inherit cpp-dev riscv-cross;
  };

  ysyx =
    let
      python-pkgs = python-dev.override {
        pyPkgs = (ps: with ps; [
          psutil
          pyyaml
        ]);
      };
    in
    nixpkgs.callPackage ./ysyx.nix {
      inherit (packages) mill;
      verilator = packages.verilator.override { version = "5.018"; };
      bloop = packages.bloop.override { version = "1.5.15"; };
      python-dev = python-pkgs;
      inherit riscv-dev;
    };

  self-dev =
    let
      python-pkgs = python-dev.override {
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
        nixpkgs-fmt
        nixd
      ];
      inputsFrom = [ python-pkgs ];
    };
}
