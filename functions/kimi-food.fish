function kimi-food --description "Run a NutriKit food-scan prompt variant against image(s). Usage: kimi-food [--front PATH] [--nutrition PATH] [--version vN] [--model ID]"
    set -l front ""
    set -l nutrition ""
    set -l version ""
    set -l model ""

    set -l i 1
    while test $i -le (count $argv)
        set -l arg $argv[$i]
        switch $arg
            case --front -f
                set i (math $i + 1)
                set front $argv[$i]
            case --nutrition -n
                set i (math $i + 1)
                set nutrition $argv[$i]
            case --version -v
                set i (math $i + 1)
                set version $argv[$i]
            case --model -m
                set i (math $i + 1)
                set model $argv[$i]
            case -h --help
                echo "usage: kimi-food [--front PATH] [--nutrition PATH] [--version vN] [--model ID]"
                echo ""
                echo "Variants (pick one with --version, or via picker if omitted):"
                __kimi_food_list_versions
                echo ""
                echo "Models (pick one with --model, or via picker if omitted):"
                __kimi_list_models
                echo ""
                echo "KIMI_API_KEY env var overrides the embedded dev key."
                return 0
            case '*'
                echo "error: unexpected arg '$arg'" >&2
                return 2
        end
        set i (math $i + 1)
    end

    if test -z "$front" -a -z "$nutrition"
        echo "error: need at least one of --front or --nutrition" >&2
        echo ""
        echo "usage: kimi-food [--front PATH] [--nutrition PATH] [--version vN] [--model ID]"
        return 2
    end

    # Validate paths early so the picker UI isn't shown for bad input.
    if test -n "$front" -a ! -f "$front"
        echo "error: --front file not found: $front" >&2
        return 2
    end
    if test -n "$nutrition" -a ! -f "$nutrition"
        echo "error: --nutrition file not found: $nutrition" >&2
        return 2
    end

    if test -z "$version"
        set version (__kimi_food_pick_version)
        if test -z "$version"
            echo "cancelled"
            return 1
        end
    end

    if test -z "$model"
        set model (__kimi_pick_model)
        if test -z "$model"
            echo "cancelled"
            return 1
        end
    end

    set -l api_key $KIMI_API_KEY
    if test -z "$api_key"
        # Same dev key as kimi-song; for testing only.
        set api_key "sk-kjAqkbxUpWFhftgnuAAxiOdiigxQHdhyt5OYCBVC1WlArKYf"
    end

    set -l front_arg "-"
    set -l nutrition_arg "-"
    if test -n "$front"
        set front_arg $front
    end
    if test -n "$nutrition"
        set nutrition_arg $nutrition
    end

    __kimi_call_food $version $front_arg $nutrition_arg $model $api_key
end
