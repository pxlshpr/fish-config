function c --description "Clone project for task and launch Claude"
    set num $argv[1]
    if test -z "$num"
        echo "Usage: c <task-number>"
        return 1
    end
    set project (basename $PWD)
    set parent (dirname $PWD)
    set clone "$parent/$project-$num"
    git clone --local $PWD $clone
    and cd $clone
    and git checkout -b $num
    and claude --dangerously-skip-permissions
end
