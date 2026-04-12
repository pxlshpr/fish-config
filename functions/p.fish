function p -d "cd into a Developer project"
    set -l base_projects Chunes Fade NutriKit Pace Spare Tasks Zones

    # Collect branch dirs (e.g. NutriKit-443)
    set -l branch_projects
    for proj in $base_projects
        for dir in ~/Developer/$proj-*
            if test -d $dir
                set -a branch_projects (basename $dir)
            end
        end
    end

    # Sort helper: returns projects sorted by git index mtime descending
    set -l branch_entries
    for proj in $branch_projects
        set -l dir ~/Developer/$proj
        set -l ts 0
        if test -f $dir/.git/index
            set ts (stat -f '%m' $dir/.git/index)
        else if test -d $dir
            set ts (stat -f '%m' $dir)
        end
        set -a branch_entries "$ts $proj"
    end
    set -l sorted_branches (printf '%s\n' $branch_entries | sort -rn | string replace -r '^\S+ ' '')

    set -l base_entries
    for proj in $base_projects
        set -l dir ~/Developer/$proj
        set -l ts 0
        if test -f $dir/.git/index
            set ts (stat -f '%m' $dir/.git/index)
        else if test -d $dir
            set ts (stat -f '%m' $dir)
        end
        set -a base_entries "$ts $proj"
    end
    set -l sorted_bases (printf '%s\n' $base_entries | sort -rn | string replace -r '^\S+ ' '')

    # Branch dirs first, then base projects
    set -l ordered $sorted_branches $sorted_bases

    set -l selected (printf '%s\n' $ordered | gum choose --header "Projects")

    if test -n "$selected"
        cd ~/Developer/$selected
    end
end
