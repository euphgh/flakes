{ self, nixpkgs, home-manager, ... }@inputs:
let
  makeCallable = attrset:
    let
      callPackage = f: override:
        f ((builtins.intersectAttrs (builtins.functionArgs f) attrset) // override);
    in
    attrset // { inherit callPackage; };

  overrideAttrSet = self:
    self // { override = newAttrSet: overrideAttrSet (makeCallable (self // newAttrSet)); };
  lib = nixpkgs.lib;
in
rec {

  #path info
  rootPath = ./..;
  devShellsDir = rootPath + /devShells;
  homeConfigsDir = rootPath + /home;
  nixosConfigsDir = rootPath + /nixos;
  homeModulesDir = rootPath + /modules/home;
  nixosModulesDir = rootPath + /modules/sys;

  # write a callable and overridable attrbute set
  fooParamSet = overrideAttrSet (makeCallable { });

  # default system enum
  defaultSysList = [ "aarch64-darwin" "aarch64-linux" "x86_64-darwin" "x86_64-linux" ];

  # make devShell or package
  foreachSysInList = sys: f: nixpkgs.lib.genAttrs (sys) (system:
    let p = { nixpkgs = nixpkgs.legacyPackages.${system}; }; in f p);

  # create nixos like normal
  createNixOS = sysAttrSet:
    let
      transNixOS = name: value:
        let
          paramSet = value;
        in
        nixpkgs.lib.nixosSystem {
          # system: must specifiy
          inherit (paramSet) system;

          # modules: must specifiy, put all modules there
          modules = with paramSet; [
            nur.nixosModules.nur
            self.outputs.nixosModules.euphgh.sys
          ] ++ [ (nixosConfigsDir + "/${name}") ];

          # specialArgs: optianl, submodule argment
          specialArgs = paramSet // { hostname = name; };
        };
    in
    lib.mapAttrs transNixOS sysAttrSet;


  evalHomeModule = { username, system, ... }@paramSet:
    home-manager.lib.homeManagerConfiguration {
      # pkgs: required, pkgs for home-manager, no overlay
      pkgs = nixpkgs.legacyPackages.${system};

      # modules: required, put all modules there
      modules = with paramSet; [
        nur.nixosModules.nur
        self.outputs.nixosModules.euphgh.home
      ] ++ [ (homeConfigsDir + "/${username}") ];

      # specialArgs: optianl, home-manager submodule argment
      extraSpecialArgs = paramSet;
    };



  #create home-manager

  #   mkBoolOption = { ... }@args:
  #     let
  #       inputs = {
  #         default = false;
  #         example = true;
  #         type = lib.types.bool;
  #       } // args;
  #     in
  #     lib.mkOption inputs;
}
