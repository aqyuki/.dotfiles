# Go
export GOPATH=$XDG_DATA_HOME/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:/usr/local/go/bin:$GOBIN

# Rust
export RUSTUP_HOME=$XDG_DATA_HOME/rustup
export CARGO_HOME=$XDG_DATA_HOME/cargo
source $CARGO_HOME/env
eval "$(rustup completions zsh)"

# mise
eval "$(mise activate zsh)"
eval "$(mise completion zsh)"

# task
eval "$(task --completion zsh)"

# dblab
eval "$(dblab completion zsh)"

# ghq
export GHQ_ROOT=$HOME/.projects

# fzf
export FZF_DEFAULT_OPTS='--height 50% --reverse --border=rounded'

# zoxide
eval "$(zoxide init zsh)"
export _ZO_FZF_OPTS=$FZF_DEFAULT_OPTS

# zabrze
eval "$(zabrze init --bind-keys)"
