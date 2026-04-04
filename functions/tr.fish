function tr -d "rename tmux session"
    if test (count $argv) -eq 2
        tmux rename-session -t "$argv[1]" "$argv[2]"
        echo "Renamed '$argv[1]' to '$argv[2]'"
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

    read -l -P "Rename session: " choice
    if test -n "$choice"
        set -l name (echo $sessions[(math $choice)] | cut -d: -f1)
        read -l -P "New name: " new_name
        if test -n "$new_name"
            tmux rename-session -t "$name" "$new_name"
            echo "Renamed '$name' to '$new_name'"
        end
    end
end
