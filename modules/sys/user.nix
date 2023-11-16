{ config, lib, stateVersion, inputs, ... }:
with lib; let
  cfg = config.euphgh.sys.users;
  utils = inputs.self.utils;
  createUserAndHome = usersAttrset:
    let
      transUserDefine = name: value:
        let
          userConfig = {
            isNormalUser = true;
            description = "";
            extraGroups = [ "wheel" ];
            initialPassword = "nix";
          } // value;
        in
        mkIf cfg.${name}.enable userConfig;

      transHomeConfig = name: value:
        let
          homeModule = { ... }: {
            imports = [ (../../home + "/${name}") ];
            home = {
              stateVersion = stateVersion;
              username = name;
              homeDirectory = "/home/${name}";
            };
          };
        in
        mkIf cfg.${name}.withHome homeModule;
    in
    {
      users.users = (lib.attrsets.mapAttrs transUserDefine usersAttrset);
      home-manager.users = (lib.attrsets.mapAttrs transHomeConfig usersAttrset);
    };
in
{
  options.euphgh.sys.users = {
    hgh = {
      enable = mkEnableOption "user 'hgh' (myself)";
      withHome = mkEnableOption "config hgh's home";
    };
    foo = {
      enable = mkEnableOption "user 'foo' (test user)";
      withHome = mkEnableOption "config foo's home";
    };
  };

  # define user like config.users.users
  config = createUserAndHome {
    hgh = {
      description = "Guanghui Hu";
    };
    foo = {
      description = "minimal user for test";
    };
  };
}
