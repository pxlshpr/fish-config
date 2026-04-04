function d -d "Download"
    set -l REMOTE pxlhome
    set -l IS_LOCAL false
    if test (hostname) = "$REMOTE"
        set IS_LOCAL true
    end
    set -l WATCH_DIR '$HOME/Downloads/plex/youtube/watch'
    set -l MUSIC_DIR '$HOME/Downloads/plex/music'
    set -l MOVIES_DIR '$HOME/Downloads/plex/movies'
    set -l TV_DIR '$HOME/Downloads/plex/tv\ shows'
    set -l COMICS_DIR '$HOME/Downloads/Comics/DC'
    set -l V_PARALLEL 10
    set -l A_PARALLEL 15
    set -l V_OPTS '--cookies-from-browser safari -f "bestvideo[height<=1440]+bestaudio/best[height<=1440]" --merge-output-format mkv -o "%(title)s.%(ext)s" --write-thumbnail --convert-thumbnails jpg --write-subs --write-auto-subs --sub-langs "en.*,-live_chat" --convert-subs srt --embed-subs --write-description --embed-metadata --embed-chapters --no-overwrites'
    set -l A_OPTS '--cookies-from-browser safari -x --audio-format mp3 --audio-quality 0 -o "%(title)s.%(ext)s" --write-thumbnail --convert-thumbnails jpg --write-description --embed-metadata --no-overwrites'
    set -l SC_OPTS '-S proto -x --audio-format mp3 --audio-quality 0 -o "%(uploader)s/%(title)s/%(title)s.%(ext)s" --parse-metadata "%(title)s:%(meta_album)s" --parse-metadata "1:%(meta_track)s" --write-thumbnail --convert-thumbnails jpg --embed-thumbnail --embed-metadata --write-description --no-overwrites'
    set -l SC_SET_OPTS '-S proto -x --audio-format mp3 --audio-quality 0 -o "%(uploader)s/%(playlist_title)s/%(title)s.%(ext)s" --parse-metadata "%(playlist_title)s:%(meta_album)s" --parse-metadata "%(playlist_index)s/%(n_entries)s:%(meta_track)s" --write-thumbnail --convert-thumbnails jpg --embed-thumbnail --embed-metadata --write-description --no-overwrites'
    set -l CLEAR_PY '$HOME/.config/yt-playlist-manager/venv/bin/python3 $HOME/.config/yt-playlist-manager/clear-playlist.py'
    set -l PLEX_DESC '$HOME/.config/yt-playlist-manager/plex-set-descriptions.sh'
    set -l WATCH_PLAYLIST 'https://www.youtube.com/playlist?list=PLw48jcLsHxP0Gpq1aU6PHGQFOTtSW8lJQ'
    set -l WATCH_PLAYLIST_ID 'PLw48jcLsHxP0Gpq1aU6PHGQFOTtSW8lJQ'
    set -l KOMGA_SCAN 'curl -s -X POST -u "pxlshpr@gmail.com:Ch1ll0ut" http://localhost:25600/api/v1/libraries/0PR5P5YBNM1XS/scan'

    # Show top-level menu if no args
    if test (count $argv) -eq 0
        echo ""
        echo "  Download"
        echo ""
        echo "  1) Comics"
        echo "  2) Music"
        echo "  3) Video"
        echo "  4) Quick download     yt-dlp + Chrome (local)"
        echo ""
        echo "  s) Status"
        echo "  l) Logs"
        echo ""
        read -l -P "  Choice: " choice
        test -z "$choice"; and return 0
    else
        set -l choice $argv[1]
    end

    set -l ts (date +%H%M%S)
    set -l sess ""
    set -l script ""

    switch $choice
        # ── Comics ──
        case 1
            read -l -P "  Magnet link or URL: " url
            test -z "$url"; and return 1
            set -l magnet
            if string match -q 'magnet:*' "$url"
                set magnet "$url"
            else
                echo "  Scraping magnet link..."
                set magnet (curl -sL "$url" | grep -oE 'magnet:\?[^"'"'"' <]+' | head -1)
                if test -z "$magnet"
                    echo "  No magnet link found on page."
                    return 1
                end
            end
            ssh pxlhome "mkdir -p $COMICS_DIR && transmission-cli -w $COMICS_DIR -u 10 -f ~/.config/transmission/finish.sh -m '$magnet' && $KOMGA_SCAN"
            return

        # ── Music ──
        case 2
            echo ""
            echo "  Music → Plex"
            echo ""
            echo "  1) SoundCloud"
            echo "  2) Torrent"
            echo "  3) YouTube playlist"
            echo "  4) YouTube track"
            echo ""
            read -l -P "  Choice: " sub
            test -z "$sub"; and return 0

            switch $sub
                case 1 # SoundCloud
                    read -l -P "  URL: " url
                    test -z "$url"; and return 1
                    set sess "sc-$ts"
                    if string match -q '*/sets/*' "$url"
                        set script "mkdir -p $MUSIC_DIR && cd $MUSIC_DIR && yt-dlp $SC_SET_OPTS \"$url\" && bash \$HOME/.config/dl-renumber-sc.sh $MUSIC_DIR && bash \$HOME/.config/dl-sc-artist-meta.sh $MUSIC_DIR"
                    else
                        set script "mkdir -p $MUSIC_DIR && cd $MUSIC_DIR && yt-dlp $SC_OPTS \"$url\" && bash \$HOME/.config/dl-renumber-sc.sh $MUSIC_DIR && bash \$HOME/.config/dl-sc-artist-meta.sh $MUSIC_DIR"
                    end

                case 2 # Music torrent
                    read -l -P "  Magnet link or URL: " url
                    test -z "$url"; and return 1
                    set -l magnet
                    if string match -q 'magnet:*' "$url"
                        set magnet "$url"
                    else
                        echo "  Scraping magnet link..."
                        set magnet (curl -sL "$url" | grep -oE 'magnet:\?[^"'"'"' <]+' | head -1)
                        if test -z "$magnet"
                            echo "  No magnet link found on page."
                            return 1
                        end
                    end
                    ssh pxlhome "transmission-cli -w ~/Downloads/plex/music -u 10 -f ~/.config/transmission/finish.sh -m '$magnet' && curl -s -X POST 'http://127.0.0.1:32400/library/sections/all/refresh?X-Plex-Token=PMVWEgYwHhPkTnZbMSg5'"
                    return

                case 3 # YouTube playlist
                    read -l -P "  URL: " url
                    test -z "$url"; and return 1
                    set sess "mp-$ts"
                    set script "mkdir -p $MUSIC_DIR && cd $MUSIC_DIR && yt-dlp --cookies-from-browser safari --flat-playlist --print url \"$url\" | xargs -P $A_PARALLEL -I{} yt-dlp $A_OPTS {}"

                case 4 # YouTube track
                    read -l -P "  URL: " url
                    test -z "$url"; and return 1
                    set sess "m-$ts"
                    set script "mkdir -p $MUSIC_DIR && cd $MUSIC_DIR && yt-dlp $A_OPTS \"$url\""

                case '*'
                    echo "  Unknown choice: $sub"
                    return 1
            end

        # ── Video ──
        case 3
            echo ""
            echo "  Video → Plex"
            echo ""
            echo "  1) Download queue"
            echo "  2) Playlist"
            echo "  3) Single video"
            echo "  4) Torrent"
            echo ""
            read -l -P "  Choice: " sub
            test -z "$sub"; and return 0

            switch $sub
                case 1 # Download queue
                    set sess "wp-$ts"
                    set script "mkdir -p $WATCH_DIR && cd $WATCH_DIR && yt-dlp --cookies-from-browser safari --flat-playlist --print url \"$WATCH_PLAYLIST\" | xargs -P $V_PARALLEL -I{} yt-dlp $V_OPTS {} && $PLEX_DESC $WATCH_DIR && $CLEAR_PY $WATCH_PLAYLIST_ID"

                case 2 # Playlist
                    read -l -P "  URL: " url
                    test -z "$url"; and return 1
                    set sess "wp-$ts"
                    set script "mkdir -p $WATCH_DIR && cd $WATCH_DIR && yt-dlp --cookies-from-browser safari --flat-playlist --print url \"$url\" | xargs -P $V_PARALLEL -I{} yt-dlp $V_OPTS {} && $PLEX_DESC $WATCH_DIR"

                case 3 # Single video
                    read -l -P "  URL: " url
                    test -z "$url"; and return 1
                    set sess "w-$ts"
                    set script "mkdir -p $WATCH_DIR && cd $WATCH_DIR && yt-dlp $V_OPTS \"$url\" && $PLEX_DESC $WATCH_DIR"

                case 4 # Torrent
                    echo ""
                    echo "  1) Movie"
                    echo "  2) TV show"
                    echo ""
                    read -l -P "  Type: " ttype
                    test -z "$ttype"; and return 0

                    set -l dest
                    switch $ttype
                        case 1
                            set dest "$MOVIES_DIR"
                        case 2
                            set dest "$TV_DIR"
                        case '*'
                            echo "  Unknown choice: $ttype"
                            return 1
                    end

                    read -l -P "  Magnet link or URL: " url
                    test -z "$url"; and return 1
                    set -l magnet
                    if string match -q 'magnet:*' "$url"
                        set magnet "$url"
                    else
                        echo "  Scraping magnet link..."
                        set magnet (curl -sL "$url" | grep -oE 'magnet:\?[^"'"'"' <]+' | head -1)
                        if test -z "$magnet"
                            echo "  No magnet link found on page."
                            return 1
                        end
                    end
                    ssh pxlhome "mkdir -p $dest && transmission-cli -w $dest -u 10 -f ~/.config/transmission/finish.sh -m '$magnet' && curl -s -X POST 'http://127.0.0.1:32400/library/sections/all/refresh?X-Plex-Token=PMVWEgYwHhPkTnZbMSg5'"
                    return

                case '*'
                    echo "  Unknown choice: $sub"
                    return 1
            end

        # ── Quick download ──
        case 4
            read -l -P "  URL: " url
            test -z "$url"; and return 1
            yt-dlp --impersonate chrome "$url"
            return

        # ── Status ──
        case s
            if test "$IS_LOCAL" = true
                tmux list-sessions 2>/dev/null | grep -E '^(w|wp|s|sp|m|mp|sc)-' || echo '  No active downloads.'
            else
                ssh $REMOTE "tmux list-sessions 2>/dev/null | grep -E '^(w|wp|s|sp|m|mp|sc)-' || echo '  No active downloads.'"
            end
            return

        # ── Logs ──
        case l
            set -l sess_arg ""
            if test (count $argv) -ge 2
                set sess_arg $argv[2]
            end
            if test -n "$sess_arg"
                if test "$IS_LOCAL" = true
                    tmux attach-session -t "$sess_arg"
                else
                    ssh -t $REMOTE "tmux attach-session -t '$sess_arg'"
                end
                return
            end
            set -l sessions
            if test "$IS_LOCAL" = true
                set sessions (tmux list-sessions 2>/dev/null | grep -E '^(w|wp|s|sp|m|mp|sc)-')
            else
                set sessions (ssh $REMOTE "tmux list-sessions 2>/dev/null | grep -E '^(w|wp|s|sp|m|mp|sc)-'")
            end
            if test (count $sessions) -eq 0
                echo "  No download sessions."
                return
            end
            echo ""
            set -l i 1
            for s in $sessions
                echo "  $i) $s"
                set i (math $i + 1)
            end
            echo ""
            read -l -P "  Attach to: " pick
            test -z "$pick"; and return 0
            set -l name (echo $sessions[(math $pick)] | cut -d: -f1)
            if test "$IS_LOCAL" = true
                tmux attach-session -t "$name"
            else
                ssh -t $REMOTE "tmux attach-session -t '$name'"
            end
            return

        case '*'
            echo "  Unknown choice: $choice"
            return 1
    end

    # Append Plex scan to script
    set script "$script && curl -s -X POST 'http://127.0.0.1:32400/library/sections/all/refresh?X-Plex-Token=PMVWEgYwHhPkTnZbMSg5' && echo 'Plex library scan triggered.'"

    # Run via tmux on remote
    if test "$IS_LOCAL" = true
        printf '%s\n' '#!/bin/bash' 'set -euo pipefail' "$script" '' 'echo ""' 'echo "=== Download complete ==="' 'sleep 30' \
            > /tmp/_dl-$sess.sh && chmod +x /tmp/_dl-$sess.sh && tmux new-session -d -s $sess "bash /tmp/_dl-$sess.sh; rm -f /tmp/_dl-$sess.sh"
        echo "  Running locally — session: $sess"
    else
        printf '%s\n' '#!/bin/bash' 'set -euo pipefail' "$script" '' 'echo ""' 'echo "=== Download complete ==="' 'sleep 30' \
            | ssh $REMOTE "cat > /tmp/_dl-$sess.sh && chmod +x /tmp/_dl-$sess.sh && tmux new-session -d -s $sess 'bash /tmp/_dl-$sess.sh; rm -f /tmp/_dl-$sess.sh'"
        echo "  Running on $REMOTE — session: $sess"
    end
    echo "  Check:  d s"
    echo "  Attach: d l $sess"
end
