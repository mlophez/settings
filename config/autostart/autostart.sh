#!/usr/bin/env bash

######## FUNCTIONS ########

distrobox-run() {
  distrobox enter ${1} -- echo
}

distrobox-start() {
  if type distrobox &>/dev/null; then
    #for name in $(distrobox list --no-color | awk -F'|' '{print $2}' | grep -v "NAME" | tr '\n' ' '); do
    for name in $(distrobox list --no-color | awk -F'|' '{print $2}' | grep -v "NAME" ); do
      distrobox-run ${name} &
    done
  fi

  wait
}

set-gtk4-theme() {
  ! type gsettings &>/dev/null && return 0

  local theme=$(gsettings get org.gnome.desktop.interface gtk-theme | tr -d "'")
  [ -z "${theme}" ] && return 0

  [ -d "$HOME/.config/gtk-4.0" ] && rm -rf $HOME/.config/gtk-4.0

  ln -sf "$HOME/.local/share/themes/${theme}/gtk-4.0" $HOME/.config/gtk-4.0
}

######## MAIN ########
set-gtk4-theme
distrobox-start

exit 0
