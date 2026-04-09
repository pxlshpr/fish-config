function p -d "cd into a Developer project"
    set -l projects Chunes Fade NutriKit Pace Spare Tasks Zones

    # Sort by last worked on (git index mtime, falling back to dir mtime)
    set -l entries
    for proj in $projects
        set -l dir ~/Developer/$proj
        set -l ts 0
        if test -f $dir/.git/index
            set ts (stat -f '%m' $dir/.git/index)
        else if test -d $dir
            set ts (stat -f '%m' $dir)
        end
        set -a entries "$ts $proj"
    end
    set -l ordered (printf '%s\n' $entries | sort -rn | string replace -r '^\S+ ' '')

    set -l selected (printf '%s\n' $ordered | gum choose --header "Projects")

    if test -n "$selected"
        cd ~/Developer/$selected
    end
end
