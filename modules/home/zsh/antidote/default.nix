{ pkgs, config, lib, ... }:
let cfg = config.euphgh.home.zsh; in
{
  options.euphgh.home.zsh.antidote = lib.mkEnableOption "euphgh gui zsh with antidote";
  config = lib.mkIf cfg.antidote {
    programs.zsh = {
      enable = true;
      dotDir = ".config/zsh";
      enableCompletion = true; # complete nix command, not zsh completion
      autocd = true;
      defaultKeymap = "emacs";
      completionInit = "autoload -U compinit && compinit";
      antidote = {
        enable = true;
        plugins = [
          "romkatv/powerlevel10k"
          "zsh-users/zsh-completions" # complete for nix commands
          "zsh-users/zsh-autosuggestions"
          "zdharma-continuum/fast-syntax-highlighting kind:defer"
          "zsh-users/zsh-history-substring-search"
        ];
      };
      initExtra = ''
        bindkey -M emacs '^P' history-substring-search-up
        bindkey -M emacs '^N' history-substring-search-down
        bindkey '^[[A' history-substring-search-up
        bindkey '^[[B' history-substring-search-down

        # To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
        [[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
      '';
      initExtraFirst = ''
        # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
        # Initialization code that may require console input (password prompts, [y/n]
        # confirmations, etc.) must go above this block; everything else may go below.
        if [[ -r "$\{XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-$\{(%):-%n}.zsh" ]]; then
          source "$\{XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-$\{(%):-%n}.zsh"
        fi
      '';
    };
  };
}
