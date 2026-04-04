function x -d "open xcode project"
    if count $argv > /dev/null
        cd $argv
        xed .
        cd ..
    else
        xed .
    end
end
