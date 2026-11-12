if [[ $OSTYPE == 'darwin'* ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv zsh)"
fi

export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"
export BROWSER="$(which xdg-open)"
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
export PYTHON_HISTORY="$XDG_STATE_HOME/python_history"
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME/java"
export XDG_MENU_PREFIX=arch- kbuildsycoca6 # Fix Dolphin from not showing recommended apps
