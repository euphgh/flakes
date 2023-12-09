{
  description = "please modify your flake description here";

  inputs = {
    nixpkgs.follows = "euphgh/nixpkgs";
    euphgh.url = "github:euphgh/flakes";
  };

  outputs = { nixpkgs, ... }@inputs: {
    devShells =
      let
        # default system enum
        defaultSysList = [ "aarch64-darwin" "aarch64-linux" "x86_64-darwin" "x86_64-linux" ];

        # make devShell or package
        foreachSysInList = sys: f: nixpkgs.lib.genAttrs (sys) (system:
          f {
            nixpkgs = nixpkgs.legacyPackages.${system};
            euphghShells = inputs.euphgh.devShells.${system};
          });
      in
      foreachSysInList defaultSysList ({ euphghShells, nixpkgs, ... }: {
        ##################################################
        ######      only need modify at here        ######
        ##################################################

        # 1. only use devShell defined in euphgh flakes
        foo = euphghShells.cpp-dev;

        # 2. use devShell defined in euphgh flakes to create new devShell
        default = nixpkgs.mkShell {
          packages = with nixpkgs; [
            dtc # for spike compile
            bc # for Linux kernel build
            ncurses # for menuconfig
          ];
          inputsFrom = [
            euphghShells.riscv-cross
            euphghShells.cpp-dev
          ];
          shellHook = '' export ARCH=riscv '';
        };
      });
  };
}
