{ pkgs, config, lib, ... }:
with lib; let cfg = config.euphgh.home.tmux; in
{
  options.euphgh.home.tmux.enable = mkEnableOption "euphgh tmux";
  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      shortcut = "a";
      escapeTime = 0;
      secureSocket = false;
      keyMode = "vi";
      shell = "${pkgs.zsh}/bin/zsh";
      extraConfig = ''
        source ${./config/mytmux.conf}
      '';
      plugins = with pkgs.tmuxPlugins; [
        vim-tmux-navigator
        nord
      ];
    };
  };
}
