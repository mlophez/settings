#!/usr/bin/env zsh

# FLATPAK
[ -e "/etc/profile.d/flatpak.sh" ] && \
  source /etc/profile.d/flatpak.sh

# NIX
[ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ] && \
  source $HOME/.nix-profile/etc/profile.d/nix.sh

# NIX LOCALE
[ -f "/usr/lib/locale/locale-archive" ] && \
  export LOCALE_ARCHIVE=/usr/lib/locale/locale-archive

# LOGIN
[[ -z $WAYLAND_DISPLAY ]] && [[ $(tty) = /dev/tty1 ]] && \
  exec nixGL Hyprland
