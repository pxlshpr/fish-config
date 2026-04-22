function __kimi_call_merged --description "Internal: invoke the merged song+artist Kimi helper. Args: title artist album model api_key"
    python3 ~/.config/fish/helpers/kimi_tag.py merged $argv[1] $argv[2] $argv[3] $argv[4] $argv[5]
end
