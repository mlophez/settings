#!/bin/bash

DISTROBOX_ENABLED="yes"
DISTROBOX_NAME="workstation"
DISTROBOX_IMAGE="localhost/workstation:latest"

#[ -e "$HOME/start.sh" ] && exec "$HOME/start.sh"

# FLATPAK
# [ -e "/etc/profile.d/flatpak.sh" ] && \
#   source /etc/profile.d/flatpak.sh

start-hyprland-nix() {
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
  exec systemd-run --user --scope --unit=hyprland.scope --slice=session.slice -- nixGL Hyprland
}

start-hyprland-distrobox() {
  #distrobox rm -f ${DISTROBOX_NAME}
  if [ "$(distrobox list | grep " ${DISTROBOX_NAME} " | wc -l)" -eq 0 ]; then
    distrobox create -n ${DISTROBOX_NAME} \
      --nvidia --no-entry -Y \
      --image ${DISTROBOX_IMAGE} \
      --volume /lib/modules:/lib/modules:rslave \
      --volume /run/dbus:/run/dbus:ro \
      --volume /run/systemd:/run/systemd:ro \
      --volume /run/udev:/run/udev:ro \
      -a "--cgroupns=host" \
      -a "--cap-add=SYS_PTRACE"
      #--volume /proc:/proc:ro \
      #-a "--security-opt label=disable --cgroupns=host --device /dev/dri --device /dev/input"
      #--volume /tmp/.X11-unix:/tmp/.X11-unix \
  fi

  export PATH=${HOME}/.local/bin:${PATH}
  export TZ=Europe/Madrid
  exec distrobox enter ${DISTROBOX_NAME} -- systemd-run --user --scope --unit=hyprland.scope --slice=session.slice -- Hyprland
}

[[ -z $WAYLAND_DISPLAY ]] && [[ $(tty) = /dev/tty1 ]] && \
  start-hyprland-distrobox
