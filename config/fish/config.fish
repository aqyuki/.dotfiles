if status is-interactive
    # Commands to run in interactive sessions can go here
end

#=============== Environment variables ===============#
set --export XDG_CONFIG_HOME $HOME/.config
set --export XDG_DATA_HOME $HOME/.local/share
set --export XDG_STATE_HOME $HOME/.local/state
set --export XDG_CACHE_HOME $HOME/.cache
set --export XDG_BIN_HOME $HOME/.local/bin

# Append XDG_BIN_HOME to PATH
fish_add_path $XDG_BIN_HOME

# Go
set --unexport GO_INSTALL_PATH /usr/local/go
set --export GOPATH $XDG_DATA_HOME/go
set --export GOBIN $GOPATH/bin
fish_add_path $GO_INSTALL_PATH/bin
fish_add_path $GOBIN

# Rust
set --export RUSTUP_HOME $XDG_DATA_HOME/rustup
set --export CARGO_HOME $XDG_DATA_HOME/cargo
source $XDG_DATA_HOME/cargo/env.fish

#=============== Tool settings ===============#
mise activate fish | source
task --completion fish | source
zoxide init fish | source
rustup completions fish | source
source $CARGO_HOME/env.fish
set --export GHQ_ROOT $HOME/.projects
set --export FZF_DEFAULT_OPTS '--height 50% --reverse --border=rounded'
set --export _ZO_FZF_OPTS $FZF_DEFAULT_OPTS

#=============== Abbreviations ===============#
abbr --add lg lazygit
abbr --add prt 'cd (git rev-parse --show-toplevel)'
abbr --add ic 'git commit --allow-empty --message="🎉 Initial commit"'

#=============== Key bindings ===============#
bind \cr __fzf_repository_search
bind \ec __fzf_change_working_directory

#=============== Prompt ===============#
set --export STARSHIP_CONFIG $XDG_CONFIG_HOME/starship/starship.toml
starship init fish | source
