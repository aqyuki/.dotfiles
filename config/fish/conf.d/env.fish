# Register XDG Based Directories
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
