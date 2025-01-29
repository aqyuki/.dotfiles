if status is-interactive
    # Commands to run in interactive sessions can go here
end

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
