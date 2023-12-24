{ pkgs, lib, config, ... }:
with lib; let cfg = config.euphgh.home.utilCli; in
{
  options.euphgh.home.utilCli.enable = mkEnableOption "util command line tools";
  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        appimage-run
        btop
        dig
        fd
        ripgrep
        sops
        trashy
        xclip
      ];
    };
  };
}
