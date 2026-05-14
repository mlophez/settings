function tm
    set -l session_name $argv[1]
    test -z "$session_name"; and set session_name 0

    if tmux ls 2>/dev/null | grep -q "^$session_name:"
        tmux attach-session -t $session_name
    else
        tmux -2 new-session -d -s $session_name -n HOME
        tmux attach-session -t $session_name
    end
end
