{ lib, pkgs, config, ... }:
with lib; let cfg = config.euphgh.home.tex;
in
{
  options.euphgh.home.tex.enable = mkEnableOption "TeXLive Full";
  config = mkIf cfg.enable {
    home.packages = [
      (pkgs.texlive.combine {
        inherit (pkgs.texlive) scheme-full;
      })
    ];
  };
}