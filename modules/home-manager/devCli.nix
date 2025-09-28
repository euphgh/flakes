{ pkgs, lib, config, ... }:
with lib; let cfg = config.euphgh.home.devCli; in
{
  options.euphgh.home.devCli.enable = mkEnableOption "develop command line tools";
  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        file
        gnumake
        ninja
        gdb
        git
        nixd
        nixfmt-rfc-style
        patchelf
        python3
        stdenv.cc
      ];
    };
  };
}
