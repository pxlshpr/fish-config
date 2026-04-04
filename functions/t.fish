function t -d "Interactive tmux menu"
    set -l reset (set_color normal)
    set -l bold (set_color --bold)
    set -l dim (set_color brblack)
    set -l yellow (set_color yellow)

    echo ""
    echo "$bold Tmux $reset"
    echo "  $yellow""1$reset) New session"
    echo "  $yellow""2$reset) Attach session"
    echo "  $yellow""3$reset) Kill session"
    echo "  $yellow""4$reset) Rename session"
    echo "  $yellow""5$reset) Detach"
    echo "  $yellow""6$reset) List sessions"
    echo ""

    read -l -P "Choice: " choice

    switch $choice
        case 1
            read -l -P "Session name: " name
            if test -n "$name"
                tmux new-session -s "$name"
            end
        case 2
            __t_session_menu attach
        case 3
            __t_session_menu kill
        case 4
            __t_session_menu rename
        case 5
            if test -n "$TMUX"
                tmux detach-client
            else
                echo "Not in a tmux session"
            end
        case 6
            echo ""
            tmux list-sessions 2>/dev/null; or echo "No sessions"
        case '*'
            return
    end
end

function __t_session_menu -d "Sub-menu for tmux session operations"
    set -l action $argv[1]
    set -l reset (set_color normal)
    set -l bold (set_color --bold)
    set -l yellow (set_color yellow)

    set -l sessions (tmux list-sessions 2>/dev/null)
    if test -z "$sessions"
        echo "No tmux sessions"
        return 1
    end

    echo ""
    echo "Sessions:"
    set -l i 1
    for s in $sessions
        echo "  $yellow""$i$reset) $s"
        set i (math $i + 1)
    end
    echo ""

    switch $action
        case attach
            read -l -P "Attach to: " choice
            if test -n "$choice"; and test "$choice" -ge 1 2>/dev/null; and test "$choice" -le (count $sessions) 2>/dev/null
                set -l name (echo $sessions[(math $choice)] | cut -d: -f1)
                tmux attach-session -t "$name"
            end
        case kill
            read -l -P "Kill: " choice
            if test -n "$choice"; and test "$choice" -ge 1 2>/dev/null; and test "$choice" -le (count $sessions) 2>/dev/null
                set -l name (echo $sessions[(math $choice)] | cut -d: -f1)
                tmux kill-session -t "$name"
                echo "Killed: $name"
            end
        case rename
            read -l -P "Rename: " choice
            if test -n "$choice"; and test "$choice" -ge 1 2>/dev/null; and test "$choice" -le (count $sessions) 2>/dev/null
                set -l name (echo $sessions[(math $choice)] | cut -d: -f1)
                read -l -P "New name: " new_name
                if test -n "$new_name"
                    tmux rename-session -t "$name" "$new_name"
                    echo "Renamed '$name' to '$new_name'"
                end
            end
    end
end
