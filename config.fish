fish_add_path ~/.local/bin
fish_add_path ~/.cargo/bin

# Env vars
set -gx TMUX_TMPDIR /tmp
set -gx CLAUDE_CODE_NO_FLICKER 1
set -gx TASKS_CONVEX_URL "https://small-aardvark-573.eu-west-1.convex.cloud"

# Disable bobthefish greeting (uname/uptime)
function fish_greeting
end

cd ~

function __apply_bobthefish_scheme --on-event fish_prompt
    if string match -q "Dark" (defaults read -g AppleInterfaceStyle 2>/dev/null)
        set -g theme_color_scheme dark
    else
        set -g theme_color_scheme light
    end
end

if status is-interactive
    if test (hostname -s) = pxlbook
        p
    else
        cd ~/
    end
end
