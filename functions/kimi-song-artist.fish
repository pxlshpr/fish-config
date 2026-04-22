function kimi-song-artist --description "Call Kimi twice — once for the song and once for the artist alone — then print the merged (union) tags. Useful for artists like Invent Animate where per-song lookups miss the band's overall genre. Usage: kimi-song-artist 'Title - Artist' [--model id] [--album 'Album']"
    set -l input ""
    set -l album ""
    set -l model ""

    set -l i 1
    while test $i -le (count $argv)
        set -l arg $argv[$i]
        switch $arg
            case --model -m
                set i (math $i + 1)
                set model $argv[$i]
            case --album -a
                set i (math $i + 1)
                set album $argv[$i]
            case '*'
                if test -z "$input"
                    set input $arg
                else
                    echo "error: unexpected arg '$arg'"
                    return 2
                end
        end
        set i (math $i + 1)
    end

    if test -z "$input"
        echo "usage: kimi-song-artist 'Title - Artist' [--model id] [--album 'Album']"
        echo ""
        __kimi_list_models
        return 2
    end

    if test -z "$model"
        set model (__kimi_pick_model)
        if test -z "$model"
            echo "cancelled"
            return 1
        end
    end

    set -l title (echo $input | awk -F ' - ' '{for(i=1;i<NF;i++) printf "%s%s", $i, (i<NF-1 ? " - " : ""); print ""}')
    set -l artist (echo $input | awk -F ' - ' '{print $NF}')

    if test -z "$title" -o -z "$artist"
        echo "error: could not parse '$input' as 'Title - Artist'"
        return 2
    end

    set -l api_key $KIMI_API_KEY
    if test -z "$api_key"
        set api_key "sk-eeulrVSbWRBjD3W0Y46tEFPVzphjuVadKmb2bmRX1VshVcaL"
    end

    echo "=== Prompts ==="
    echo "Song:   $artist - $title"
    echo "Artist: $artist"
    if test -n "$album"
        echo "Album:  $album"
    end
    echo "Model:  $model"
    echo ""

    __kimi_call_merged "$title" "$artist" "$album" "$model" "$api_key"
end
