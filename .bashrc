[[ -n $PS1 ]] || return

HISTCONTROL=ignoredups:ignorespace
HISTSIZE=100000
HISTFILESIZE=200000

shopt -s histappend
shopt -s autocd
shopt -s cdspell
shopt -s checkwinsize
shopt -s dirspell
shopt -s extglob

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

PS1="[\d \t]-[\u@\h:\w]\$ "

export EDITOR='nvim'
export VISUAL='nvim'
export MANPAGER='less'
export PAGER='less'

alias nc='ncat'
alias l='ls'
alias ll='ls -lha'
alias ls='ls -p --color=auto'

command -v xdg-open &>/dev/null &&
    alias open='xdg-open'

force_color_prompt=yes

. ~/.bash_completion

export PATH=~/.local/bin/:$PATH
