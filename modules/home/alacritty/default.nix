{ config, lib, ... }:
with lib; let cfg = config.euphgh.home.alacritty; in
{
  options.euphgh.home.alacritty.enable = mkEnableOption "euphgh alacritty";
  config = mkIf cfg.enable {
    programs.alacritty = {
      enable = true;
    };
  };
}
