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
        foreachSysInList = sys: f: nixpkgs.lib.genAttrs (sys) (system: f {
          nixpkgs = nixpkgs.legacyPackages.${system};
          devShells = inputs.euphgh.devShells.${system};
          packages = inputs.euphgh.packages.${system};
        });
      in
      foreachSysInList defaultSysList ({ devShells, nixpkgs, packages, ... }: {
        ##################################################
        ######      only need modify at here        ######
        ##################################################

        # 1. use devShell defined in euphgh flakes
        inherit (devShells) cpp-dev python-dev riscv-dev ysyx;

        # 2. use euphgh's devShell to create new devShell
        general = nixpkgs.mkShell {
          packages = with nixpkgs; [
            zlib
            autoconf
            perl
            flex
            bison
            python3
            help2man
            cmakeWithGui
            perl538Packages.DevelTrace
          ];
          inputsFrom = [ devShells.cpp-dev ];
        };
      });
  };
}
