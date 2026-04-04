function p -d "cd into a Developer project"
    set -l projects Chunes Fade NutriKit Pace Spare Tasks Zones

    set -l selected (printf '%s\n' $projects | gum choose --header "Projects")

    if test -n "$selected"
        cd ~/Developer/$selected
    end
end
