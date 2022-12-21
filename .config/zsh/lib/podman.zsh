#!/usr/bin/zsh

alias docker="podman"
alias dc="docker-compose"

#alias host="distrobox-host-exec"
alias host-bash="distrobox-host-exec bash --norc"

alias podman="host podman"
alias flatpak="host flatpak"
alias distrobox="host distrobox"


function host() {
  if [ -n "$container" ]; then
    command distrobox-host-exec "$@"
  else
    command "$@"
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

## APPS
function jenkins-run() {
  mkdir -p $HOME/.local/share/volumes/jenkins &>/dev/null

  autossh -M 20001 -N -R 9090:127.0.0.1:8080 demo-public-a-haproxy &>/dev/null &

  podman run --rm --network=host \
    -v $HOME/.local/share/volumes/jenkins:/var/jenkins_home \
    -e "JENKINS_OPTS=--prefix=/jenkins" \
    --user root --name jenkins docker.io/jenkins/jenkins:lts

  fg
}
