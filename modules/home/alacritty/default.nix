{ config, lib, ... }:
with lib; let cfg = config.euphgh.home.vscode; in
{
  options.euphgh.home.alacritty.enable = mkEnableOption "euphgh alacritty";
  config = mkIf cfg.enable {
    programs.alacritty = {
      enable = true;
    };
  };
}
