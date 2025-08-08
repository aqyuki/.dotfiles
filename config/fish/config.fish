set -Ux EDITOR (which nvim)
set -Ux VISUAL (which nvim)

set -Ux XDG_CONFIG_HOME $HOME/.config
set -Ux XDG_CACHE_HOME $HOME/.cache
set -Ux XDG_DATA_HOME $HOME/.local/share
set -Ux XDG_STATE_HOME $HOME/.local/state

set -Ux XDG_BIN_HOME $HOME/.local/share/bin
fish_add_path $XDG_BIN_HOME

# setup go command
fish_add_path /usr/local/go/bin
fish_add_path (go env GOBIN)

# add alias
abbr -a lg lazygit
abbr -a tmp "cd (mktemp --directory)"
abbr -a cgr "cd (git rev-parse --show-superproject-working-tree --show-toplevel | head -1)"

# activate mise
mise activate fish | source
mise completion fish | source

# GHQ settings
set -Ux GHQ_ROOT $XDG_DATA_HOME/projects

# activate fzf integration
fzf --fish | source
set -Ux FZF_DEFAULT_OPTS '--height 50% --layout reverse --border rounded'
bind \cg __fzf_project_directory

# load prompt
starship init fish | source
