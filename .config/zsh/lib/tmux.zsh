#!/usr/bin/zsh

alias tmux="command tmux -f $HOME/.config/tmux/tmux.conf"
function tm() {
    local session_name=$1
    [ -z "$session_name" ] && session_name=$USER

    if [ -n "$(tmux ls 2>/dev/null | grep $session_name:)" ]; then
        exec tmux attach-session -t $session_name
    else
        if [ "$session_name" = "$USER" ]; then
            #tmux start-server
            tmux -2 new-session -d -s $session_name -n LOCAL
        else
            tmux -2 new-session -d -s $session_name -n LOCAL
        fi
        exec tmux attach-session -t $session_name
    fi
}
