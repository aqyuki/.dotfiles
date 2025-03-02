autoload -Uz compinit && compinit

# Load custom scripts
[[ -f "$XDG_CONFIG_HOME/zsh/custom/tool.zsh" ]] && source "$XDG_CONFIG_HOME/zsh/custom/tool.zsh"
[[ -f "$XDG_CONFIG_HOME/zsh/custom/util.zsh" ]] && source "$XDG_CONFIG_HOME/zsh/custom/util.zsh"
[[ -f "$XDG_CONFIG_HOME/zsh/custom/plugin.zsh" ]] && source "$XDG_CONFIG_HOME/zsh/custom/plugin.zsh"
[[ -f "$XDG_CONFIG_HOME/zsh/custom/prompt.zsh" ]] && source "$XDG_CONFIG_HOME/zsh/custom/prompt.zsh"
