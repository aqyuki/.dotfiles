function __fzf_repository_search --description "find local repository with fzf"
    set src (ghq list | fzf --preview fzf --preview 'lsd --almost-all --color=always --ignore-glob=".git" --literal --tree --depth 2 $(ghq root)/{}')
    if test -n "$src"
        cd (ghq root)/$src
    end
    commandline -f repaint
end
