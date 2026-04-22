function __kimi_pick_model --description "Interactive numbered picker for Kimi models. Prints the chosen model id on stdout."
    set -l ids \
        kimi-k2-thinking \
        kimi-k2-thinking-turbo \
        kimi-k2.5 \
        kimi-k2-turbo-preview \
        kimi-k2-0905-preview \
        kimi-k2-0711-preview \
        kimi-latest \
        moonshot-v1-128k \
        moonshot-v1-32k \
        moonshot-v1-8k \
        moonshot-v1-auto

    __kimi_list_models >&2
    echo "" >&2
    echo -n "Pick a model [1-"(count $ids)"] (default 5 = kimi-k2-0905-preview): " >&2
    read -l choice
    if test -z "$choice"
        set choice 5
    end
    if not string match -qr '^\d+$' -- $choice
        echo "invalid choice: $choice" >&2
        return 1
    end
    if test $choice -lt 1 -o $choice -gt (count $ids)
        echo "out of range: $choice" >&2
        return 1
    end
    echo $ids[$choice]
end
