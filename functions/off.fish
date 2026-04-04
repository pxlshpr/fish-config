function off -d "start OFF API server"
    set -l pid (lsof -ti:3333 2>/dev/null)
    if test -n "$pid"
        echo "⚠️  Server already running (PID: $pid)"
        echo "   Use 'off-stop' to stop it first"
        return 1
    end

    echo "🚀 Starting OFF API server on port 3333..."
    nohup /Volumes/LaCie/off_data/venv/bin/python3 /Users/pxlshpr/Developer/NutriKit/off_prototype/off_api_production.py > /tmp/off-server.log 2>&1 &
    sleep 2

    set -l new_pid (lsof -ti:3333 2>/dev/null)
    if test -n "$new_pid"
        echo "✅ Server started (PID: $new_pid)"
        echo "   Endpoint: http://localhost:3333"
        echo "   Logs: /tmp/off-server.log"
    else
        echo "❌ Failed to start server. Check logs:"
        tail -10 /tmp/off-server.log
    end
end

function off-stop -d "stop OFF API server"
    set -l pid (lsof -ti:3333 2>/dev/null)
    if test -z "$pid"
        echo "⚠️  No server running on port 3333"
        return 1
    end

    kill -9 $pid 2>/dev/null
    echo "✅ Server stopped (PID: $pid)"
end

function off-status -d "OFF API server status"
    set -l pid (lsof -ti:3333 2>/dev/null)
    if test -n "$pid"
        echo "✅ Server running (PID: $pid)"
        echo "   Testing connection..."
        set -l response (curl -s -o /dev/null -w "%{http_code}" http://localhost:3333/stats 2>/dev/null)
        if test "$response" = "200"
            curl -s http://localhost:3333/stats | python3 -m json.tool
        else
            echo "   ⚠️  Server not responding (HTTP $response)"
        end
    else
        echo "❌ Server not running"
    end
end
