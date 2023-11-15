{ config, lib, pkgs, ... }:
with lib; let
  cfg = config.euphgh.sys.hgh;
in
{
  options.euphgh.sys.hgh.enable = mkEnableOption "user 'hgh' (myself)";
  config = mkIf cfg.enable {
    users.users.hgh = {
      isNormalUser = true;
      description = "Guanghui Hu";
      extraGroups = [ "wheel" ];
      initialPassword = "nix";
    };
  };
}
