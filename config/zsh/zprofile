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

# HOME MANAGER
[ -f "~/.nix-profile/etc/profile.d/hm-session-vars.sh" ] && \
  source ~/.nix-profile/etc/profile.d/hm-session-vars.sh

# LOGIN
[[ -z $WAYLAND_DISPLAY ]] && [[ $(tty) = /dev/tty1 ]] && \
  exec systemd-run --user --scope --unit=hyprland.scope --slice=desktop.slice -- nixGL Hyprland
  # exec nixGL Hyprland
  # exec nice -n 0 ionice -c 2 -n 0 nixGL Hyprland

#[[ -z $WAYLAND_DISPLAY ]] && [[ $(tty) = /dev/tty2 ]] && \
#  exec /usr/bin/start-cosmic
