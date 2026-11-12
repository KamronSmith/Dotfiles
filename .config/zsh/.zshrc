HISTFILE="$HOME/.config/zsh/zhistory"
HISTSIZE=100000
SAVEHIST=200000
setopt AUTOCD
setopt EXTENDEDGLOB
setopt NOMATCH
setopt NOTIFY
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
unsetopt beep

OS_NAME=$(uname -s)

case "$OS_NAME" in
    Linux*)
        export SSH_AUTH_SOCK="$HOME/.1password/agent.sock"
        export GIT_SSH_SIGNING_PROGRAM="/opt/1Password/op-ssh-sign"
        ;;

    Darwin*)
        export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
        export GIT_SSH_SIGNING_PROGRAM="/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
        ;;
esac

export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"
export EDITOR="emacsclient -c -a ''"
export GIT_EDITOR="$EDITOR"
export PROMPT="[%n@%m:%~]$ "
export VISUAL="$EDITOR"
export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"

alias wget="wget --hsts-file=$XDG_DATA_HOME/wget-hsts"
alias vim="nvim"
alias vi="nvim"
alias n="nvim"

zstyle :compinstall filename '/home/kam/.config/zsh/.zshrc'

autoload -Uz compinit
compinit

bindkey -e
bindkey -e '^w' kill-whole-line
bindkey -e '^\b' backward-kill-word

stty -ixon # stops ctrl-s from freezing the terminal
