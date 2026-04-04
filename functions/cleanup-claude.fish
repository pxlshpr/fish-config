function cleanup-claude -d "kill old claude processes"
    set -l current_pid $fish_pid
    echo "Current process PID: $current_pid"
    echo "Looking for old Claude processes..."
    echo ""

    set -l all_pids (ps aux | grep "claude" | grep -v grep | awk '{print $2}')

    if test -z "$all_pids"
        echo "No Claude processes found!"
        return 0
    end

    set -l to_kill
    for pid in $all_pids
        if test "$pid" != "$current_pid"
            set -a to_kill $pid
        end
    end

    if test -z "$to_kill"
        echo "No old Claude processes to clean up!"
        return 0
    end

    echo "Found "(count $to_kill)" old Claude process(es) to remove:"
    echo ""

    for pid in $to_kill
        set -l info (ps -p $pid -o command= 2>/dev/null)
        echo "  PID $pid: $info"
    end

    echo ""
    read -l -P "Delete these processes? (y/n) " confirm

    if test "$confirm" = "y" -o "$confirm" = "Y"
        for pid in $to_kill
            echo "Killing PID $pid..."
            kill -9 $pid 2>/dev/null && echo "  ✓ Killed" || echo "  ✗ Failed or already gone"
        end
        echo ""
        echo "Cleanup complete!"
    else
        echo "Cancelled."
        return 1
    end
end
