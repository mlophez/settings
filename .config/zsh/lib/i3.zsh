#!/usr/bin/zsh

[ "$XDG_CURRENT_DESKTOP" != "i3" ] && return

export DISPLAY=":0"

function clipboard() {
    xclip -i -r -sel clip "$@"
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
    eval "i3-msg exec \"zsh -i -c '$@'\""
}

function daemonize_test() {
    echo "i3-msg exec \"zsh -i -c '$@'\""
}

function x11config() {
}

function i3border() {
    python << EOF
#!/usr/bin/python

import i3ipc
import time

i3 = i3ipc.Connection()

def borderfocus(i3, event):
	i3.command("border pixel $1")

i3.on("window::focus", borderfocus)
i3.main()
EOF
}

function monitor() {
}

function onexit() {
    mail_stop
}

function deskexit() {
    i3-msg exit
}

function i3blocks-battery() {
    local device=BAT0
    local capacity=$(cat /sys/class/power_supply/$device/capacity)
    local stats=$(cat /sys/class/power_supply/$device/status)
    
    [[ $stats = "Full" || $capacity -eq 100 ]] && echo "<span foreground=\"#01EC08\"></span> $capacity%" && return 0
    [[ $stats = "Discharging" && $capacity -lt 10 ]] && echo "<span foreground=\"red\"></span> $capacity%" && return 0
    [[ $stats = "Discharging" ]] && echo "<span foreground=\"yellow\"></span> $capacity%" && return 0
    [[ $stats = "Charging" ]] && echo "<span foreground=\"#01EC08\"></span> $capacity%" && return 0
    [[ $stats = "Unknown" ]] && echo "<span foreground=\"#01EC08\"></span> $capacity%" && return 0
    
    echo "$stats $capacity%"
}
