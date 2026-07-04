OS_NAME=$(uname -s)

case "$OS_NAME" in
    Linux*)
        export SSH_AUTH_SOCK="$HOME/.1password/agent.sock"
        ;;

    Darwin*)
        export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
        ;;
esac

export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"
export EDITOR="emacsclient -c -a ''"
export GIT_EDITOR="$EDITOR"
export VISUAL="$EDITOR"
export PROMPT="[%n@%m:%~]$ "
export BROWSER="firefox"
export SSH_AUTH_SOCK="$HOME/.1password/agent.sock"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
export PYTHON_HISTORY="$XDG_STATE_HOME/python_history"

export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$CARGO_HOME"
export PATH="$PATH:$HOME/.zvm/bin"
export PATH="$PATH:$HOME/.zvm/self"
