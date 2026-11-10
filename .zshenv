export ZDOTDIR=$HOME/.config/zsh

OS_NAME=$(uname -s)

case "$OS_NAME" in
    Linux*)
        export SSH_AUTH_SOCK="$HOME/.1password/agent.sock"
        export GIT_SSH_SIGNING_PROGRAM="/opt/1Password/op-ssh-sign"
        ;;

    Darwin*)
        export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
        export GIT_SSH_SIGNING_PROGRAM="/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
        ;;
esac

export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"
export EDITOR="emacsclient -c -a ''"
export GIT_EDITOR="$EDITOR"
export VISUAL="$EDITOR"
export GNUGPGHOME="$XDG_CONFIG_HOME/gnupg"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"

export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$CARGO_HOME"
export PATH="$PATH:$RUSTUP_HOME"
export PATH="$PATH:$HOME/.zvm/bin"
export PATH="$PATH:$HOME/.zvm/self"
