{ config, lib, pkgs, ... }:
with lib; let cfg = config.euphgh.home.contour; in
{
  options.euphgh.home.contour.enable = mkEnableOption "euphgh alacritty";
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      contour
    ];
  };
}
