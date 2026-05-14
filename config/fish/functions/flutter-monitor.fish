function flutter-monitor
    while true
        if not test -e /tmp/flutter.pid
            echo "[-] NO PID"
            return 1
        end
        if not test -d lib
            echo "[-] NO LIB FOLDER FOUND"
            return 1
        end
        find lib/ -name '*.dart' | entr -d -p kill -USR1 (cat /tmp/flutter.pid)
        sleep 0.1
    end
end
