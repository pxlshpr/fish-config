function kimi-song-v5 --description "Run the Chunes Kimi song-tagging prompt (v5: explicit artist-name pattern matching, empty-on-unknown escape hatch). Usage: kimi-song-v5 'Title - Artist' [--model id] [--album 'Album Name']"
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
        echo "usage: kimi-song-v5 'Title - Artist' [--model id] [--album 'Album Name']"
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

    echo "=== Prompt (v5) ==="
    echo "Song: $artist - $title"
    if test -n "$album"
        echo "Album: $album"
    end
    echo "Model: $model"
    echo ""
    echo "=== Kimi response ==="

    __kimi_call_song_v5 "$title" "$artist" "$album" "$model" "$api_key"
end
