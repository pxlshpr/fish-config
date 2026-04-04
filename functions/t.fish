function t -d "Interactive tmux menu"
    set -l choice (gum choose --header "Tmux" \
        "New session" \
        "Attach session" \
        "Kill session" \
        "Rename session" \
        "Detach" \
        "List sessions")

    switch $choice
        case "New session"
            set -l name (gum input --placeholder "Session name")
            if test -n "$name"
                tmux new-session -s "$name"
            end
        case "Attach session"
            __t_session_menu attach
        case "Kill session"
            __t_session_menu kill
        case "Rename session"
            __t_session_menu rename
        case "Detach"
            if test -n "$TMUX"
                tmux detach-client
            else
                echo "Not in a tmux session"
            end
        case "List sessions"
            echo ""
            tmux list-sessions 2>/dev/null; or echo "No sessions"
    end
end

function __t_session_menu -d "Sub-menu for tmux session operations"
    set -l action $argv[1]

    set -l sessions (tmux list-sessions -F "#{session_name}" 2>/dev/null)
    if test -z "$sessions"
        echo "No tmux sessions"
        return 1
    end

    switch $action
        case attach
            set -l name (printf '%s\n' $sessions | gum choose --header "Attach to session")
            if test -n "$name"
                tmux attach-session -t "$name"
            end
        case kill
            set -l name (printf '%s\n' $sessions | gum choose --header "Kill session")
            if test -n "$name"
                tmux kill-session -t "$name"
                echo "Killed: $name"
            end
        case rename
            set -l name (printf '%s\n' $sessions | gum choose --header "Rename session")
            if test -n "$name"
                set -l new_name (gum input --placeholder "New name")
                if test -n "$new_name"
                    tmux rename-session -t "$name" "$new_name"
                    echo "Renamed '$name' to '$new_name'"
                end
            end
    end
end
