#!/usr/bin/zsh

##### ALIAS

# ANSIBLE
alias playbook="ansible-playbook"
alias inventory="ansible-inventory"

# GIT
alias g="git_menu"
alias wk="workspace"

# DOCKER PODMAN
alias docker="podman"
alias dc="docker-compose"
alias podman="distrobox-host podman"
alias flatpak="distrobox-host flatpak"
alias distrobox="distrobox-host distrobox"
alias se="service"

##### FUNCTIONS

# GIT
function git_menu() {
  local cmd
  local opts=(
    "undo: git reset --soft HEAD~1"
    "fetch: git fetch -p -P"
    "main: git checkout main"
    "clean: git checkout main && git branch | grep -v 'main' | xargs -I@ git branch -D @"
    "pull: git pull"
    "push: git push"
    "datecommit: git commit -m \"$(date '+%Y-%m-%d %H:%M:%S')\""
    "add: git add . && git status"
    "discard: git restore ."
    "random-branch: git_generate_random_branch"
  )

  cmd=$(printf '%s\n' "${opts[@]}" | fzf --layout=default)
  [ -z "$cmd" ] && return 0

  echo "-> $cmd"
  eval "$(echo $cmd | cut -d ":" -f 2-100000000 | sed 's/^ *//g')"
}

function git_generate_random_branch() {
  local random=$[ $RANDOM % 5000000 + 1000000 ]
  local username="miguellopez"

  git checkout main
  git pull

  git checkout -b $username-$random
  git push --set-upstream origin $username-$random
}

# function git() {
#   if [ "$(command git remote -v | grep origin | grep -o "platform.logalty.com")" ]; then
#     git config user.name "Your Name"
#     git config user.email "youremail@yourdomain.com"
#   fi
#   command git "$@"
# }

function workspace() {
  local wpath=($(find $HOME -maxdepth 2 -iname Projects -type d -print | tr '\n' ' '))
  cd $(find $wpath -mindepth 1 -maxdepth 1 -type d -print | fzf)
}

# PODMAN
function distrobox-host() {
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
function service() {
  local cmd
  local opts=(
    "jenkins"
    "postgresql"
  )

  cmd=$(printf '%s\n' "${opts[@]}" | fzf)
  [ -z "$cmd" ] && return 0

  echo "-> $cmd"
  eval "_service_$cmd"

  podman volume prune
}

function _service_jenkins() {
  mkdir -p $HOME/.local/share/volumes/jenkins &>/dev/null

  autossh -M 20001 -N -R 9090:127.0.0.1:8080 demo-public-a-haproxy &>/dev/null &

  podman run --rm --network=host \
    -v $HOME/.local/share/volumes/jenkins:/var/jenkins_home \
    -e "JENKINS_OPTS=--prefix=/jenkins" \
    --user root --name jenkins docker.io/jenkins/jenkins:lts

  fg
}

function _service_postgresql() {
  podman run --rm --network=host \
    -e "POSTGRES_DB=logalty" \
    -e "POSTGRES_USER=flyway" \
    -e "POSTGRES_PASSWORD=T3mp0r4l" \
    --user root --name postgres docker.io/postgres:latest
    #-e PGDATA=/var/lib/postgresql/data/pgdata \
}

function flyway() {
  local args
  [ -d "$(pwd)/sql" ] && args="-v $(pwd)/sql:/flyway/sql"
  [ -d "$(pwd)/postgresql" ] && args="-v $(pwd)/postgresql:/flyway/sql"
  [ -d "$(pwd)/postgres" ] && args="-v $(pwd)/postgres:/flyway/sql"

  eval podman run --rm --network=host $args docker.io/flyway/flyway "$@"
}
