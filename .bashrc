[ -z "$PS1" ] && return

HISTCONTROL=ignoredups:ignorespace

shopt -s histappend

HISTSIZE=100000
HISTFILESIZE=200000

shopt -s checkwinsize

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

PS1="[\d \t]-[\u@\h:\w]\$ "

alias nc="ncat"

force_color_prompt=yes

export PATH=~/.local/bin/:$PATH
