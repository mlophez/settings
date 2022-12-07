#!/usr/bin/zsh

alias docker="podman"
alias dc="docker-compose"

alias host="distrobox-host-exec"
alias host-bash="distrobox-host-exec bash -l"

function podman() {
  if [ "$container" = "podman" ]; then
    command distrobox-host-exec podman "$@"
  else
    command podman "$@"
  fi
}

function distrobox-install() {
  curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sh -s -- --prefix ~/.local 
}

function distrobox-uninstall() {
  curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sh -s -- --next --prefix ~/.local
}

function distrobox-archlinux() {
  $HOME/.local/bin/distrobox-create -i docker.io/archlinux:latest -n archlinux
  $HOME/.local/bin/distrobox enter archlinux
}

function distrobox-packages() {
  local packagefile="$HOME/.config/zsh/res/toolbox/archlinux.packages"
  sudo pacman --needed -S $(cat $packagefile | grep -v "^ *#" | grep -v "^ *$" | tr "\n" " ")
}
