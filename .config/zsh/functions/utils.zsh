#!/usr/bin/zsh

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

function editor() {
    export TERM=xterm-256color
    command nvim "$@"
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
