function __kimi_call_song_v3 --description 'Internal: invoke the Chunes Kimi song-tagging helper with the v3 prompt. Args: title artist album model api_key'
    python3 ~/.config/fish/helpers/kimi_tag.py song-v3 $argv[1] $argv[2] $argv[3] $argv[4] $argv[5]
end
