#!/usr/bin/zsh

alias reload="exec zsh"
alias ll="ls -lh"
alias mkdir="command mkdir -vp"

alias info="notify-send -u low -t 3000"
alias warn="notify-send -u normal -t 3000"
alias critical="notify-send -u critical -t 3000"

alias server-up="wol 00:4e:01:c5:bb:49"
alias server-ssh="sshn root@192.168.1.230"
alias server-tunnel="ssh -N -D5555 root@192.168.1.230"

alias audio-hdmi="pactl set-card-profile 0 output:hdmi-stereo-extra1"
alias audio-micro="pactl set-card-profile 0 output:analog-stereo+input:analog-stereo"

# Underscore blinking # printf "\e[5 q" # Vertical Line }
function precmd() {
    # printf "\e[3 q"
    #printf "\e]12;red\x7;\e[5 q"
    printf "\e[5 q"
}

function timezsh() {
  local shell=${1-$SHELL}
  local i
  for i in $(seq 1 10); do time $shell -i -c exit; done
}

function ls() {
  local afunctrace=($functrace) 
  if [[ ${#afunctrace[@]} -le 1 ]]; then
    if type lsd &>/dev/null; then
      lsd -S "$@"
    else
      command ls -S --color "$@"
    fi
  else
    command ls -S "$@"
  fi
}

function cat() {
  if type bat &>/dev/null; then
    bat "$@"
  else
    command cat "$@"
  fi
}

function clipboard() {
    if [ "$XDG_SESSION_TYPE" = "x11" ]; then
        xclip -i -r -sel clip "$@"
    else
        wl-copy -n "$@"
    fi
}

function x11config() {
    export GDK_BACKEND=x11
    export QT_QPA_PLATFORM=xcb
    export CLUTTER_BACKEND=x11
    export SDL_VIDEODRIVER=x11
    export WINIT_UNIX_BACKEND=x11
}

