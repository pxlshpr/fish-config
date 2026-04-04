function tn -d "new tmux session"
    if test (count $argv) -eq 0
        echo "Usage: tn <session-name>"
        return 1
    end
    tmux new-session -s "$argv[1]"
end
