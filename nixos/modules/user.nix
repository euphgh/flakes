{ config, lib, pkgs, ... }:
with lib; let
  cfg = config.euphgh.hgh;
in
{
  options.euphgh.hgh.enable = mkEnableOption "user 'hgh' (myself)";
  config = mkIf cfg.enable {
    users.users.hgh = {
      isNormalUser = true;
      description = "Guanghui Hu";
      extraGroups = [ "wheel" ];
      initialPassword = "nix";
    };
  };
}
