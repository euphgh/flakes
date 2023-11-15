{ pkgs, lib, config, ... }:
with lib; let cfg = config.euphgh.home.utilCli; in
{
  options.euphgh.home.utilCli.enable = mkEnableOption "util command line tools";
  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        file
        gnumake
        gdb
        patchelf
        python3
        stdenv.cc
      ];
    };
  };
}
