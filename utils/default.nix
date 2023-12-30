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
  packagesDir = rootPath + /packages;
  homeConfigsDir = rootPath + /home;
  nixosConfigsDir = rootPath + /nixos;
  homeModulesDir = rootPath + /modules/home;
  nixosModulesDir = rootPath + /modules/sys;

  defaultParamSet = {
    system = "x86_64-linux";
    stateVersion = "23.05";
  } // inputs;

  # write a callable and overridable attrbute set
  callableAndoverridable = overrideAttrSet (makeCallable { });

  # default system enum
  defaultSysList = [ "aarch64-darwin" "aarch64-linux" "x86_64-darwin" "x86_64-linux" ];

  # make devShell or package
  foreachSysInList = sys: f: nixpkgs.lib.genAttrs (sys) (system:
    let
      p = {
        nixpkgs = nixpkgs.legacyPackages.${system};
        inherit system self;
      };
    in
    f p);

  mapIfExist = ele: f: list:
    let
      mapFn = x: if x == ele then (f x) else x;
    in
    builtins.map mapFn list;

  dir2Conf = dir: attrs:
    let
      inherit (builtins) readDir concatLists;
      dirInfo = readDir dir;
      dirMapFn = name: value: defaultParamSet // {
        modules = [ (dir + /${name}) ];
      };
      flkMapFn = name: value: defaultParamSet // value // {
        modules = concatLists [
          value.append
          (if dirInfo?${name} then [ (dir + /${name}) ] else [ ])
        ];
      };
    in
    lib.mapAttrs dirMapFn dirInfo // lib.mapAttrs flkMapFn attrs;

  # create nixos with special args
  createNixOS = attrs:
    let
      makeNixOS = name: value:
        let specialArgs = builtins.removeAttrs value [ "modules" "append" ];
        in
        nixpkgs.lib.nixosSystem {
          # system: must specifiy
          inherit (specialArgs) system;

          # modules: must specifiy, put all modules there
          modules = with specialArgs; [
            nur.nixosModules.nur
            self.outputs.nixosModules.euphgh.sys
          ] ++ value.modules;

          # specialArgs: optianl, submodule argment
          specialArgs = specialArgs // { hostname = name; };
        };
    in
    lib.mapAttrs makeNixOS (dir2Conf nixosConfigsDir attrs);

  # create home with speical args
  createHome = attrs:
    let
      makeHome = name: value:
        let
          specialArgs = (defaultParamSet // { system = builtins.currentSystem; }) // value;
        in
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${specialArgs.system};
          modules = with specialArgs; [
            nur.nixosModules.nur
            self.outputs.nixosModules.euphgh.home
            ({ ... }: {
              config.euphgh.home.specialArgs = {
                username = name;
              };
            })
          ] ++ value.modules;
          extraSpecialArgs = specialArgs;
        };
    in
    lib.mapAttrs makeHome (dir2Conf homeConfigsDir attrs);

  # speical variable for home in nixos
  defaultHome = homeConfigsDir;
}
