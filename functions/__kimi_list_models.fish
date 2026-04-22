function __kimi_list_models --description "Print the curated list of Kimi models for the kimi-song picker"
    set -l models \
        "kimi-k2-thinking|Best accuracy. Deep-reasoning k2 model — correctly tagged Invent Animate as Djent/Prog Metal in testing. High completion-token cost." \
        "kimi-k2-thinking-turbo|Fast thinking variant. Slightly less thorough than kimi-k2-thinking but still very accurate." \
        "kimi-k2.5|Latest k2.5 generation. Requires temperature=1 (hardcoded). Accurate, current flagship." \
        "kimi-k2-turbo-preview|Fast non-thinking k2. Cheap and accurate — good cost/quality tradeoff." \
        "kimi-k2-0905-preview|Dated k2 snapshot (Sep 2025). Accurate and cheap. Good default." \
        "kimi-k2-0711-preview|Earlier k2 snapshot (Jul 2025). Accurate." \
        "kimi-latest|Routes to whatever Moonshot considers current (often moonshot-v1-32k)." \
        "moonshot-v1-128k|LEGACY. Current Chunes prod model. Mis-tagged Invent Animate as Pop/Synth Pop." \
        "moonshot-v1-32k|LEGACY. Mis-tagged Invent Animate as Synth Pop/Pop/Dancehall." \
        "moonshot-v1-8k|LEGACY. Smallest/cheapest moonshot v1 model." \
        "moonshot-v1-auto|LEGACY auto-router. Routes to a v1-* model."

    echo "Models:"
    set -l i 1
    for entry in $models
        set -l id (string split -m1 "|" -- $entry)[1]
        set -l desc (string split -m1 "|" -- $entry)[2]
        printf "  %2d) %-26s  %s\n" $i $id $desc
        set i (math $i + 1)
    end
end
