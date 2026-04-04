function h -d "Show custom fish commands reference"
    set -l reset (set_color normal)
    set -l bold (set_color --bold)
    set -l dim (set_color brblack)
    set -l cyan (set_color cyan)
    set -l green (set_color green)
    set -l yellow (set_color yellow)
    set -l blue (set_color blue)

    # If a specific command is given, show its detail
    if test (count $argv) -gt 0
        __h_detail $argv[1]
        return
    end

    echo ""
    echo "$bold Downloads $reset"
    echo "  $cyan""dl$reset $dim""w|wp|s|sp|m|mp|status|logs$reset  YouTube/SoundCloud downloader (tmux)"
    echo "  $cyan""y$reset $dim""<url>$reset                         yt-dlp with Chrome impersonation"
    echo "  $cyan""ym$reset $dim""<url>$reset                        yt-dlp playlist audio to Plex"
    echo "  $cyan""tm$reset $dim""<url|magnet>$reset                  Torrent via pxlhome transmission"

    echo ""
    echo "$bold Git $reset"
    echo "  $green""gs$reset                                git status"
    echo "  $green""gl$reset                                git log --oneline"
    echo "  $green""gb$reset                                add, commit \"bump\", push"
    echo "  $green""gp$reset $dim""\"msg\"$reset                        add, commit with message, push"

    echo ""
    echo "$bold Tmux $reset"
    echo "  $yellow""t$reset                                 interactive tmux menu"
    echo "  $yellow""tl$reset                                list sessions"
    echo "  $yellow""ta$reset $dim""[name]$reset                       attach session (interactive menu)"
    echo "  $yellow""td$reset $dim""[name]$reset                       kill session (interactive menu)"
    echo "  $yellow""tr$reset $dim""[old new]$reset                    rename session (interactive menu)"
    echo "  $yellow""tn$reset $dim""<name>$reset                       new session"
    echo "  $yellow""tx$reset                                detach from current session"

    echo ""
    echo "$bold Misc $reset"
    echo "  $blue""o$reset                                 open current dir in Finder"
    echo "  $blue""cleanup-claude$reset                     kill old Claude processes"
    echo ""
    echo "  $dim""h <command> for more detail$reset"
    echo ""
end

function __h_detail -d "Show detailed help for a specific command"
    set -l cmd $argv[1]
    set -l reset (set_color normal)
    set -l bold (set_color --bold)
    set -l dim (set_color brblack)
    set -l cyan (set_color cyan)

    echo ""

    switch $cmd
        case dl
            echo "$bold""dl$reset - YouTube/SoundCloud downloader (runs in tmux)"
            echo ""
            echo "  $cyan""dl w <url>$reset        download video to watch (1080p, subs, artwork)"
            echo "  $cyan""dl wp [url]$reset       download watch playlist (10 parallel)"
            echo "  $cyan""dl s <url>$reset        download video to share"
            echo "  $cyan""dl sp [url]$reset       download share playlist (10 parallel)"
            echo "  $cyan""dl m <url>$reset        download audio only (mp3)"
            echo "  $cyan""dl mp <url>$reset       download music playlist (15 parallel)"
            echo "  $cyan""dl <sc-url>$reset       auto-detect SoundCloud track"
            echo "  $cyan""dl status$reset         show active downloads"
            echo "  $cyan""dl logs [name]$reset    attach to download tmux session"
            echo ""
            echo "  $dim""Runs remotely on pxlhome if not on local machine$reset"
            echo "  $dim""Downloads go to ~/Downloads/plex/ for Plex integration$reset"

        case tm
            echo "$bold""tm$reset - Torrent downloader"
            echo ""
            echo "  $cyan""tm <url>$reset          scrapes magnet link from page"
            echo "  $cyan""tm magnet:?...$reset    direct magnet link"
            echo ""
            echo "  $dim""Sends to transmission-cli on pxlhome$reset"
            echo "  $dim""Downloads to ~/Downloads/plex/music$reset"

        case gp gb
            echo "$bold""gp / gb$reset - Quick git commit+push shortcuts"
            echo ""
            echo "  $cyan""gp \"msg\"$reset          add all, commit with message, push"
            echo "  $cyan""gb$reset                add all, commit \"bump\", push"

        case t
            echo "$bold""t$reset - Interactive tmux menu"
            echo ""
            echo "  Presents a numbered menu:"
            echo "  1) New session     - prompts for name"
            echo "  2) Attach session  - shows session list"
            echo "  3) List sessions"
            echo "  4) Kill session    - shows session list"
            echo "  5) Rename session  - shows session list"
            echo "  6) Detach"

        case ta td tr tn tx tl
            echo "$bold""Tmux shortcuts$reset"
            echo ""
            echo "  $cyan""tl$reset               list sessions"
            echo "  $cyan""ta [name]$reset         attach (shows interactive menu if no name)"
            echo "  $cyan""td [name]$reset         kill session (interactive menu if no name)"
            echo "  $cyan""tr [old new]$reset      rename (interactive menu if no args)"
            echo "  $cyan""tn <name>$reset         new session with name"
            echo "  $cyan""tx$reset               detach from current session"

        case y
            echo "$bold""y$reset - yt-dlp with Chrome impersonation"
            echo ""
            echo "  $cyan""y <url>$reset"

        case ym
            echo "$bold""ym$reset - Download playlist as audio"
            echo ""
            echo "  $cyan""ym <url>$reset"
            echo ""
            echo "  $dim""Downloads to ~/Downloads/plex/music with playlist folders$reset"

        case '*'
            echo "No detailed help for '$cmd'"
            echo ""
            echo "Run $cyan""h$reset for the full reference"
    end
    echo ""
end
