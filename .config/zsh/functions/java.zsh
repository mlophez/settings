#!/usr/bin/zsh

function java_menu() {
    local entry=$(archlinux-java status | grep "^ " | sed 's/^ *//g' |cut -d" " -f1 | fzf)
    [ -z "$entry" ] && return
    sudo archlinux-java set $entry
}


