#!/usr/bin/zsh

[ "$XDG_CURRENT_DESKTOP" != "sway" ] && return

export SWAYSOCK=/run/user/$(id -u)/sway-ipc.$(id -u).$(pgrep -x sway).sock
export SWAY_LAPTOP_OUTPUT="eDP-1"

function clipboard() {
    wl-copy -n "$@"
}

function locking() {
    local image=$1
    echo "$@" >> /tmp/test.txt
    echo "$image" >> /tmp/test.txt

    [ -e $HOME/$image ] && image=$HOME/$image

    swaylock \
    --ignore-empty-password \
    --show-failed-attempts \
    --indicator-radius 50 \
    -f -i $image -s fill
}

function daemonize() {
    eval "swaymsg exec \"zsh -i -c '$@'\""
    # swaymsg exec "zsh -i -c '$@'"
}

function daemonize_test() {
    echo "swaymsg exec \"zsh -i -c '$@'\""
}

function x11config() {
    export GDK_BACKEND=x11
    export QT_QPA_PLATFORM=xcb
    export CLUTTER_BACKEND=x11
    export SDL_VIDEODRIVER=x11
    export WINIT_UNIX_BACKEND=x11
}

function set_screen() {
    local screen=$1
    local resolution=$2
    local position=$3

    swaymsg output $screen enable
    swaymsg output $screen resolution $resolution position \'$position\' scale 1
    daemonize /usr/lib/xdg-desktop-portal-wlr -r -o $screen
}

function reorder() {
    local laptop="eDP-1"

    local actual=$(swaymsg -t get_tree | jq '.nodes[].nodes[] | select(.nodes[].nodes[].focused==true)' | jq -r '.name')

    for external in $(swaymsg -t get_outputs | jq ".[] | select(.name!=\"$laptop\")" | jq -r '.name'); do
        swaymsg workspace $external
        swaymsg move workspace to output $external
        swaymsg 'exec $term -e /bin/bash -c "sleep 3"'
    done

    for workspace in $(swaymsg -t get_tree | jq ".nodes[] | select(.name!=\"$laptop\")" | jq -r '.nodes[].name'); do
        [[ ! "$workspace" =~ ^[0-9]*$ ]] && continue
        swaymsg workspace $workspace
        swaymsg move workspace to output $laptop
    done

    swaymsg workspace 1

    return 0
}

function sway_output_workspace() {
    local output=$(swaymsg -t get_outputs | jq ".[] | select(.name!=\"$SWAY_LAPTOP_OUTPUT\")" | jq -r '.name' | head -1)
    swaymsg workspace $output
}

function sway_output_workspace_move() {
    local output=$(swaymsg -t get_outputs | jq ".[] | select(.name!=\"$SWAY_LAPTOP_OUTPUT\")" | jq -r '.name' | head -1)
    swaymsg move workspace $output
}

function monitor-config() {
    local monitor="$1"
    local screens=$(swaymsg -t get_outputs | jq -r '.[].name')

    for s in $(echo "$screens"); do 
        [ "$s" = "$monitor" ] && continue
        swaymsg output $s disable
    done
    
    swaymsg output $monitor enable
    swaymsg output $monitor resolution "1920x1080" position "0,0" scale 1
    daemonize /usr/lib/xdg-desktop-portal-wlr -r -o $monitor

    killall waybar &>/dev/null
    daemonize waybar
}

function monitor() {
    local laptop="eDP-1"
    local screens=$(swaymsg -t get_outputs | jq -r '.[].name')
    local total=$(echo "$screen" | wc -l)

    #swaymsg workspace MON
    if [ $total -eq 1 ]; then
        swaymsg output $screen enable
        swaymsg output $screen resolution $resolution position \'$position\' scale 1
        daemonize /usr/lib/xdg-desktop-portal-wlr -r -o $screen
        #set_screen $screens '1920x1080' '0,0'
    fi

    killall waybar &>/dev/null
    daemonize waybar
}

function onexit() {
    mail_stop
}

function deskexit() {
    swaymsg exit
    #swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'
}
