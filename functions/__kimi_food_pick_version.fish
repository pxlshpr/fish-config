function __kimi_food_pick_version --description "Interactive picker for NutriKit food-scan prompt variants"
    set -l versions v1 v2 v3 v4 v5 v6 v6s
    __kimi_food_list_versions >&2
    echo "" >&2
    read -P "Pick a version [1-"(count $versions)"]: " -l choice
    if test -z "$choice"
        return 1
    end
    if not string match -qr '^[0-9]+$' -- $choice
        return 1
    end
    if test $choice -lt 1 -o $choice -gt (count $versions)
        return 1
    end
    echo $versions[$choice]
end
