function gc -d "git add, commit, push"
    command git add .
    command git commit -a -m "$argv"
    command git push
end
