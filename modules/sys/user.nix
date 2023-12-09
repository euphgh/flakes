{ config, lib, self, ... }@inputs:
with lib; let
  cfg = config.euphgh.sys.users;
  inherit (self) utils;
  createUserAndHome = usersAttrset:
    let
      transUserDefine = name: value:
        let
          userConfig = {
            isNormalUser = true;
            description = "";
            extraGroups = [ "wheel" ];
            initialPassword = "nix";
            createHome = true;
          } // (builtins.removeAttrs value [ "homeConfig" ]);
        in
        userConfig;

      transHomeConfig = name: value:
        let
          makeHomeOrNot = (value ? homeConfig)
            && (builtins.isList value.homeConfig)
            && (value.homeConfig != [ ]);
          homeModule = {
            imports = (utils.mapIfExist
              (utils.defaultHome)
              (homeRoot: homeRoot + /${name})
              (value.homeConfig)) ++ [({
                euphgh.home.specialArgs.username = name;
              })];
          };
        in
        mkIf makeHomeOrNot homeModule;
    in
    {
      users.users = (lib.mapAttrs transUserDefine usersAttrset);
      home-manager.users = (lib.mapAttrs transHomeConfig usersAttrset);
    };
in
{
  options.euphgh.sys.users = mkOption {
    default = { };
    type = types.attrs;
    example = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      homeConfig = [
        (./path/to/home-config)
        ({ ... }: {
          euphgh.home.specialArgs = {
            foo = 12;
          };
        })
        utils.defaultHome
      ];
    };
    description = ''
      any config under user.users.<name>.
      besides, `homeConfig` option can be add
      which are anything can be as home-manager imports
      if let it empty, system will not set home-manager for the user
      particular value `utils.defaultHome` is used to pointed as homeConfigsDir
      you also can define euphgh.home.specialArgs in it.
    '';
  };

  config = createUserAndHome cfg;
}
