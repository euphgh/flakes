{ pkgs, lib, config, ... }:
with lib; let cfg = config.euphgh.home.utilGui; in
{
  options.euphgh.home.utilGui.enable = mkEnableOption "common gui tools";
  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        chromium
        config.nur.repos.linyinfeng.wemeet
        flameshot
        qq
      ];
    };
  };
}
