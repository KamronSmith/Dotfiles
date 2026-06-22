HISTFILE="$HOME/.config/zsh/zhistory"
HISTSIZE=100000
SAVEHIST=200000
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
export EDITOR="emacsclient -c -a ''"
export VISUAL="$EDITOR"
export PROMPT="[%n@%m:%~]$ "
export BROWSER="firefox"
export SSH_AUTH_SOCK="$HOME/.1password/agent.sock"
export GNUPGHOME="$XDG_CONFIG_HOME/.gnupg/"
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

zstyle :compinstall filename '/home/kam/.config/zsh/.zshrc'

autoload -Uz compinit
compinit
