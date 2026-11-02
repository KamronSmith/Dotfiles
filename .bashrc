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

shopt -s autocd
shopt -s cdspell
shopt -s checkwinsize
shopt -s dirspell
shopt -s extglob

alias nc="ncat"

force_color_prompt=yes

. ~/.bash_completion

export PATH=~/.local/bin/:$PATH
