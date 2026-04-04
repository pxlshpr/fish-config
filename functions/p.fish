function p -d "cd into a Developer project"
    set -l reset (set_color normal)
    set -l bold (set_color --bold)
    set -l yellow (set_color yellow)

    set -l projects Chunes Fade NutriKit Pace Spare Tasks Zones

    echo ""
    echo "$bold Projects $reset"
    set -l i 1
    for name in $projects
        echo "  $yellow$i$reset) $name"
        set i (math $i + 1)
    end
    echo ""

    read --nchars 1 -l -P "Project: " choice

    if test $status -eq 0; and string match -qr '^[1-9]$' -- $choice
        set -l idx (string trim $choice)
        if test $idx -ge 1 2>/dev/null; and test $idx -le (count $projects) 2>/dev/null
            cd ~/Developer/$projects[$idx]
        end
    end
end
