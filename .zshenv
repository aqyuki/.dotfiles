# XDG Base Directory Specification
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state
export XDG_CACHE_HOME=$HOME/.cache
export XDG_BIN_HOME=$HOME/.local/bin

# Extra paths
export PATH=$PATH:$XDG_BIN_HOME

# Zsh settings
export ZDOTDIR=$XDG_CONFIG_HOME/zsh
export HISTFILE=$XDG_STATE_HOME/zsh/history
export HISTSIZE=1000
export SAVEHIST=1000
