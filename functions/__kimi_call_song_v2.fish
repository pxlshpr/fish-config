function __kimi_call_song_v2 --description 'Internal: invoke the Chunes Kimi song-tagging helper with the v2 prompt. Args: title artist album model api_key'
    python3 ~/.config/fish/helpers/kimi_tag.py song-v2 $argv[1] $argv[2] $argv[3] $argv[4] $argv[5]
end
