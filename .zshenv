export ZDOTDIR="$HOME/.config/zsh/"
<<<<<<< HEAD
export PATH="$HOME/.local/bin:$PATH"
export EDITOR="emacsclient -c -a ''"
export VISUAL="$EDITOR"
export PROMPT="[%n@%m:%~]$ "
export BROWSER="firefox"
export GNUPGHOME="$XDG_CONFIG_HOME/.gnupg/"

OS_NAME=$(uname -s)

case "$OS_NAME" in
    Linux*)
        export SSH_AUTH_SOCK="$HOME/.1password/agent.sock"
        ;;

    Darwin*)
        export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
        ;;
esac
=======

# ZVM
# $HOME/.zvm/bin:$HOME/.zvm/self:
# export ZVM_INSTALL="$HOME/.zvm/self"
>>>>>>> 40cc935 (Added env variables to UWSM config)
