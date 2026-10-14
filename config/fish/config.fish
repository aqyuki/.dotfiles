set --global --export XDG_CONFIG_HOME $HOME/.config
set --global --export XDG_CACHE_HOME $HOME/.cache
set --global --export XDG_DATA_HOME $HOME/.local/share
set --global --export XDG_STATE_HOME $HOME/.local/state
set --global --export XDG_BIN_HOME $HOME/.local/bin

fish_add_path $XDG_BIN_HOME

abbr --add --global lg lazygit
abbr --add --global proot 'cd (git rev-parse --show-toplevel)'
abbr --add --global --command git pf 'push --force-if-includes  --force-with-lease'

bind \cg __fzf_select_repository
