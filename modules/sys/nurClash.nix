{ config, lib, ... }:
with lib; let cfg = config.euphgh.sys.nurClash; in
{
  options.euphgh.sys.nurClash.enable = mkEnableOption "clash writen by hgh";
  config = {
    systemd.services.ClashPre = mkIf cfg.enable {
      enable = true;
      unitConfig = {
        Description = "Clash daemon, A rule-based proxy in Go.";
        After = "network-online.target";
      };
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        ExecStart = "${config.nur.repos.linyinfeng.clash-premium}/bin/clash-premium -d /home/hgh/.local/etc/clash";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
