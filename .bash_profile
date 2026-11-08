export EDITOR='nvim'
export VISUAL="$EDITOR"
export GIT_EDITOR="$EDITOR"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

if [[ -d "$HOME"/.local/bin ]]; then
    PATH="$HOME"/.local/bin/:$PATH
fi

if [[ "$TERM" == 'dumb' ]] && [[ "$INSIDE_EMACS" ]]; then
    export PAGER='cat'
    export MANPAGER='cat'
else
    export PAGER='less'
    export MANPAGER='less'
fi

if [[ -f "$HOME"/.bashrc ]]; then
    . ~/.bashrc
fi
