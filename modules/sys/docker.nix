{ config, lib, ... }:
let
  cfg = config.euphgh.sys.docker;
in
{
  options.euphgh.sys.docker.enable = lib.mkEnableOption "euphgh docker";
  config = lib.mkIf cfg.enable {
    virtualisation.docker.enable = true;
    users.users.hgh.extraGroups = [ "docker" ];
    virtualisation.docker.storageDriver = "btrfs";
    virtualisation.docker.rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
}
