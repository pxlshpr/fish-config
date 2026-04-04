function td -d "kill tmux session"
    if test (count $argv) -gt 0
        tmux kill-session -t "$argv[1]"
        echo "Killed session: $argv[1]"
        return
    end

    set -l sessions (tmux list-sessions 2>/dev/null)
    if test -z "$sessions"
        echo "No tmux sessions"
        return 1
    end

    echo "Sessions:"
    set -l i 1
    for s in $sessions
        echo "  $i) $s"
        set i (math $i + 1)
    end

    read -l -P "Kill session: " choice
    if test -n "$choice"
        set -l name (echo $sessions[(math $choice)] | cut -d: -f1)
        tmux kill-session -t "$name"
        echo "Killed session: $name"
    end
end
