{ pkgs, lib, config, ... }:
with lib; let cfg = config.euphgh.home.devCli; in
{
  options.euphgh.home.devCli.enable = mkEnableOption "develop command line tools";
  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        linuxKernel.packages.linux_6_1.perf
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
