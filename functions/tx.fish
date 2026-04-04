function tx -d "detach from tmux session"
    if test -n "$TMUX"
        tmux detach-client
    else
        echo "Not in a tmux session"
    end
end
