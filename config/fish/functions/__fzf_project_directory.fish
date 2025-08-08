function __fzf_project_directory --description "find local repository with fzf"
    set src (ghq list | fzf --preview "bat --color=always --style=header,grid --line-range :80 $(ghq root)/{}/README.*")
    if test -n "$src"
        cd (ghq root)/$src
    end
    commandline -f repaint
end
