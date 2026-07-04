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
bindkey -e

alias wget="wget --hsts-file=$XDG_DATA_HOME/wget-hsts"
alias vim="nvim"
alias vi="nvim"
alias n="nvim"

zstyle :compinstall filename '/home/kam/.config/zsh/.zshrc'

autoload -Uz compinit
compinit
