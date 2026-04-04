function gp -d "git add, commit with message, push"
    if test (count $argv) -eq 0
        echo "Usage: gp \"commit message\""
        return 1
    end

    git add .
    git commit -a -m "$argv"
    git push
end
