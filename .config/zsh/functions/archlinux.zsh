#!/bin/bash

alias arch="archlinux"

function archlinux() {
  local command="$1"; shift

  if declare -f "archlinux__$command" >/dev/null 2>&1; then
    "archlinux__$command" "$@"
  fi
}

function archlinux__configure() {
  #[[ "$(whoami)" != "root" ]] && echo "You must be run like root" && return 1
  local section="$1"
  archlinux__configure__pacman
}

function archlinux__configure__pacman() {
    print "CONFIGURE PACMAN"

    sudo sed "s/^#Color.*$/Color/g" -i /etc/pacman.conf
    sudo sed "s/^\[multilib\]/#[multilib]/g" -i /etc/pacman.conf

    #[ ! -e "/etc/pacman.d/mirrorlist.install" ] && cat /etc/pacman.d/mirrorlist > /etc/pacman.d/mirrorlist.install \
    #    && reflector --verbose --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
    #echo
}

