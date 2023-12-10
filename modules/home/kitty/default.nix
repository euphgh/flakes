{ config, lib, pkgs, ... }:
with lib; let cfg = config.euphgh.home.kitty; in
{
  options.euphgh.home.kitty.enable = mkEnableOption "euphgh kitty";
  config = mkIf cfg.enable {
    home.packages = with pkgs; [ kitty ];
  };
}
