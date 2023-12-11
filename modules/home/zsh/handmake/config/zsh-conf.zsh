setopt notify
setopt nobeep
setopt autocd

function clear-screen-and-scrollback() {
    echoti civis >"$TTY"
    printf '%b' '\e[H\e[2J' >"$TTY"
    zle .reset-prompt
    zle -R
    printf '%b' '\e[3J' >"$TTY"
    echoti cnorm >"$TTY"
}
export PATH=$PATH:~/.local/bin

zle -N clear-screen-and-scrollback
bindkey "^O" accept-search
bindkey '^[^L' clear-screen-and-scrollback
bindkey -r '^L'

# [ -z "$TMUX"  ] && tmux new -A -s main -D
# }}}
