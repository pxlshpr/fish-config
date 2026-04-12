function __find_hephaestus -d "Find hephaestus device line with retry"
    for attempt in 1 2 3
        set -l all_devices (xcrun devicectl list devices 2>/dev/null | grep -E "available \(paired\)" | grep -iv watch)
        for line in $all_devices
            if string match -qi "*hephaestus*" "$line"
                echo "$line"
                return 0
            end
        end
        if test $attempt -lt 3
            sleep 2
        end
    end
    return 1
end
