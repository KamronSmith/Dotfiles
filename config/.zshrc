export EDITOR=nvim
export XDG_CONFIG_HOME=~/.config

autoload -Uz compinit && compinit
autoload -U colors && colors

setopt share_history

setopt extended_glob
setopt auto_cd
setopt auto_pushd
setopt menu_complete

unsetopt beep match notify

export PATH+=$HOME/tools
