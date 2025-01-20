function __fzf_change_working_directory
    set -l select (fd --type d -H -E .git -E node_modules | fzf --preview 'lsd --almost-all --color=always --icon=always --literal --tree --depth 2 {}')
    if test -n "$select"
        cd $select
    end
    commandline -f repaint
end
