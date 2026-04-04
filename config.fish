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

if status is-interactive
    p
end
