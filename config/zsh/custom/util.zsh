__fzf_change_working_directory() {
  local select
  select=$(fd --type d -H -E .git -E node_modules | fzf --preview 'lsd --almost-all --color=always --icon=always --literal --tree --depth 2 {}')

  if [[ -n "$select" ]]; then
    cd "$select"
  fi

  zle reset-prompt
}
zle -N __fzf_change_working_directory
bindkey '^f' __fzf_change_working_directory

__fzf_repository_search() {
  local src
  src=$(ghq list | fzf --preview 'lsd --almost-all --color=always --ignore-glob=".git" --literal --tree --depth 2 $(ghq root)/{}')

  if [[ -n "$src" ]]; then
    cd "$(ghq root)/$src"
  fi

  zle reset-prompt
}
zle -N __fzf_repository_search
bindkey '^r' __fzf_repository_search
