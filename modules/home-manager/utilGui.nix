{ pkgs, lib, config, ... }:
let cfg = config.euphgh.home.utilGui; in
{
  options.euphgh.home.utilGui.enable = lib.mkEnableOption "common gui tools";
  config = lib.mkIf cfg.enable {
      home = {
        packages = with pkgs; [
          chromium
          nur.repos.linyinfeng.wemeet
          flameshot
          qq
        ];
      };
    };
}
