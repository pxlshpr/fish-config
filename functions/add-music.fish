function add-music --description "Add a music file to Apple Music library"
    if test (count $argv) -eq 0
        echo "Usage: add-music <path-to-file>"
        return 1
    end

    set file_path (realpath $argv[1])

    if not test -f $file_path
        echo "File not found: $file_path"
        return 1
    end

    osascript -e "tell application \"Music\" to add POSIX file \"$file_path\""
    and echo "Added: $file_path"
end
