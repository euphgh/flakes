{ lib, pkgs, config, ... }:
with lib; let cfg = config.euphgh.tex;
in
{
  options.euphgh.tex.enable = mkEnableOption "TeXLive Full";
  config = mkIf cfg.enable {
    home.packages = [
      (pkgs.texlive.combine {
        inherit (pkgs.texlive) scheme-full;
      })
    ];
  };
}