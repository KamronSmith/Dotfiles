OS_NAME=$(uname -s)

case "$OS_NAME" in
    Linux*)
        export SSH_AUTH_SOCK="$HOME/.1password/agent.sock"
        ;;

    Darwin*)
        export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
        ;;
esac
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.zvm/bin:$HOME/.zvm/self:$PATH"
export EDITOR="emacsclient -c -a ''"
export GIT_EDITOR="$EDITOR"
export VISUAL="$EDITOR"
export PROMPT="[%n@%m:%~]$ "
export BROWSER="firefox"
export SSH_AUTH_SOCK="$HOME/.1password/agent.sock"
export GNUPGHOME="$XDG_CONFIG_HOME/gnupg/"

# ZVM
# $HOME/.zvm/bin:$HOME/.zvm/self:
# export ZVM_INSTALL="$HOME/.zvm/self"
