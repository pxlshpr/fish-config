function __kimi_food_list_versions --description "Print NutriKit food-scan prompt versions for the kimi-food picker"
    set -l versions \
        "v1|baseline — two parallel calls (identity on front + nutrition on label). Matches current app." \
        "v2|merged — single call with BOTH images, current prompts merged verbatim + identity fields." \
        "v3|merged-tight — single call, pruned prompt (schema-first, no container/drained/DRI narrative)." \
        "v4|merged-json-mode — v3 + response_format=json_object, no 'return ONLY JSON' boilerplate." \
        "v5|nutrition-only — skip front label, identify from nutrition image itself (fewest image tokens)." \
        "v6|hardened merged — v3 schema + json mode + strict anti-hallucination rules and drained/container metadata." \
        "v6s|v6 but streaming — SSE with per-field timestamps to measure UX gain. Same prompt/schema as v6."

    echo "Versions:"
    set -l i 1
    for entry in $versions
        set -l id (string split -m1 "|" -- $entry)[1]
        set -l desc (string split -m1 "|" -- $entry)[2]
        printf "  %2d) %-6s  %s\n" $i $id $desc
        set i (math $i + 1)
    end
end
