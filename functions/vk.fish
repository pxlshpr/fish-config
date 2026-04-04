function vk -d "kill vapor server"
    set -l processId (ps -eaf | grep .build | tr -s ' ' | cut -d ' ' -f 2 | head -n 1)
    kill -9 $processId
    echo "Killed vapor server with pid: $processId"
end
