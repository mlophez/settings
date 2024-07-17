#!/bin/bash

# FLATPAK
# [ -e "/etc/profile.d/flatpak.sh" ] && \
#   source /etc/profile.d/flatpak.sh

# NIX
[ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ] && \
  source $HOME/.nix-profile/etc/profile.d/nix.sh

# NIX. HOME MANAGER
[ -f "~/.nix-profile/etc/profile.d/hm-session-vars.sh" ] && \
  source ~/.nix-profile/etc/profile.d/hm-session-vars.sh

# NIX LOCALE
[ -f "/usr/lib/locale/locale-archive" ] && \
  export LOCALE_ARCHIVE=/usr/lib/locale/locale-archive

# PATH
export PATH=${HOME}/.local/bin:${PATH}

# DESKTOP
[[ -z $WAYLAND_DISPLAY ]] && [[ $(tty) = /dev/tty1 ]] && \
  exec systemd-run --user --scope --unit=hyprland.scope --slice=session.slice -- nixGL Hyprland
