function fsf
    set host (grep -E "^Host" $HOME/.ssh/config | sed -e 's/Host[ ]*//g' | fzf)
    if test -n "$host"
        ssh $host
    end
end
