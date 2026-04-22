function tts --description "Toggle Kokoro TTS on/off"
    set flag "$HOME/.claude/tts_disabled"
    if test -f $flag
        rm $flag
        echo "TTS enabled"
    else
        touch $flag
        echo "TTS disabled"
    end
end
