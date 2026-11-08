export EDITOR='nvim'
export VISUAL='nvim'
export GIT_EDITOR="$EDITOR"
export VISUAL="$EDITOR"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

if [[ -d ~/.local/bin ]]; then
    export PATH=~/.local/bin/:$PATH
if [[ "$TERM" == 'dumb' ]] && [[ "$INSIDE_EMACS" ]]; then
    export PAGER='cat'
    export MANPAGER='cat'
else
    export PAGER='less'
    export MANPAGER='less'
fi

if [[ -f ~/.bashrc ]]; then
    . ~/.bashrc
fi
