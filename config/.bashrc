[ -z "$PS1" ] && return

HISTCONTROL=ignoredups:ignorespace

shopt -s histappend

HISTSIZE=100000
HISTFILESIZE=200000

shopt -s checkwinsize

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

if [ -z "$debian_chroot"] && [ -r /etc/debian_chroot]; then
   debian_chroot=$(cat /etc/debian_chroot)
fi

case "$TERM" in
    xterm-color) color_prompt=yes;;
esac



force_color_prompt=yes

export PATH=~/tools:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games

