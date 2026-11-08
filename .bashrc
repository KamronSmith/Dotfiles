[[ -n $PS1 ]] || return

stty -ixon # stops ctrl-s from freezing the terminal

HISTCONTROL=ignoredups:ignorespace
HISTSIZE=100000
HISTFILESIZE=200000

shopt -s histappend
shopt -s autocd
shopt -s cdspell
shopt -s checkwinsize
shopt -s dirspell
shopt -s extglob

# [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

PS1="[\d \t]-[\u@\h:\w]\$ "
force_color_prompt=yes

alias nc='ncat'
alias vim='nvim'
alias vi='nvim'
alias n='nvim'
alias l='ls'
alias ll='ls -lha'
alias ls='ls -p --color=auto'
alias wget="wget --hsts-file=$XDG_DATA_HOME/wget-hsts"

if [[ $OSTYPE == 'darwin'* ]]; then
    alias rm='trash'
fi

if [[ $OSTYPE == 'linux-gnu' ]]; then
    alias rm='trash-put'
fi

command -v xdg-open &>/dev/null &&
    alias open='xdg-open'

backup () {
    cp -riv $1 ${1}-$(date +%Y%m%d%H%M).bak;
}

if [[ -f ~/.bash_completion ]]; then
    . ~/.bash_completions
fi
