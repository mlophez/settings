function fkill
    set -l pid (ps -ef | sed 1d | fzf | awk '{print $2}')
    test -n "$pid"; and kill -$argv[1] $pid 2>/dev/null; or kill -9 $pid
end
