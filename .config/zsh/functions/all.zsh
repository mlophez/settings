#!/usr/bin/zsh

precmd() {
  printf "\e[5 q"
}

timezsh() {
  local shell=${1-$SHELL}
  local i
  for i in $(seq 1 10); do time $shell -i -c exit; done
}

ls() {
  local afunctrace=($functrace)
  if [[ ${#afunctrace[@]} -le 1 ]]; then
    if type exa &>/dev/null; then
      command exa --group-directories-first "$@"
    elif type lsd &>/dev/null; then
      command lsd -v --group-directories-first "$@"
    else
      command ls -v --group-directories-first --color "$@"
    fi
  else
    command ls -v --group-directories-first "$@"
  fi
}

cat() {
  if type bat &>/dev/null; then
    bat "$@"
  else
    command cat "$@"
  fi
}

kubectl() {
  local cmd="kubectl"
  local extra_args

  #[ -n "$(echo "$@" | grep -e ' -f ' -e ' -k ')" ] && extra_args="--server-side"
  type kubecolor &>/dev/null && cmd="kubecolor"

  command $cmd "$@" $extra_args
}

curl() {
  if type curlie &>/dev/null; then
    curlie "$@"
  else
    command curl "$@"
  fi
}

pip() {
  if [ "${1}" = "install" ]; then
    command pip "$@" --break-system-packages
  else
    command pip "$@"
  fi
}

### A PARTIR DE AQUI METER EN FICHEROS
kustomize-menu() {
  local entry=$(find . -path "*/overlays/*" -type f -name kustomization.yaml | xargs -I@ dirname @ | fzf)
  [ -z "$entry" ] && return 0

  local context=$(basename $(echo ${entry} | grep -o ".*overlays/[a-zA-Z0-9]*"))

  if [ "${1}" = "apply" ]; then
    print -z "kustomize build --enable-helm --load-restrictor LoadRestrictionsNone ${entry} | kubectl --context ${context} apply --server-side --force-conflicts -f -"
  elif [ "${1}" = "diff" ]; then
    print -z "kustomize build --enable-helm --load-restrictor LoadRestrictionsNone ${entry} | kubectl --context ${context} diff --server-side --force-conflicts -f -"
  elif [ "${1}" = "bundle" ]; then
    print -z "kustomize build --enable-helm --load-restrictor LoadRestrictionsNone ${entry} | tee ${entry}/bundle.yaml"
  fi
}

aws-tunnel() { # 1521:oradb01.cmu2qzz9znmw.eu-south-2.rds.amazonaws.com:1521 i-0fcd1f120811b7f42
  local target=$1
  local instance=$2
  local profile=$3

  local lport=$(echo $target | cut -d":" -f 1)
  local host=$(echo $target | cut -d":" -f 2)
  local port=$(echo $target | cut -d":" -f 3)

  aws ssm start-session --cli-read-timeout 80000 --target ${instance} \
  --document-name AWS-StartPortForwardingSessionToRemoteHost \
  --parameters "{\"host\":[\"${host}\"],\"portNumber\":[\"${port}\"],\"localPortNumber\":[\"${lport}\"]}" \
  --profile ${profile}
}

distrobox-menu () {
  local container_name=$(distrobox list --no-color | awk -F'|' '{print $2}' | grep -v "NAME" | fzf)
  [ "x$container_name" != "x" ] && eval distrobox enter $container_name
}

docker-upload-image () {
    local host=$1
    local image=$2

    [ -z "$(docker images | sed 's/  */:/g' | grep $image)" ] && echo "[-] Image dont exists" && return 1
    #[[ "$image" =~ '^localhost' ]] && docker tag "$image" "$(echo $image | sed 's#localhost/##g')"

    docker save $image | pv | ssh -C $host docker load

    if [[ "$image" =~ '^localhost' ]]; then
        ssh $host "docker tag $image $(echo $image | sed 's#localhost/##g')"
        ssh $host "docker image rm $image"
    fi
}

# FLUTTER
flutter-monitor () {
  while true; do
    [ ! -e /tmp/flutter.pid ] && echo "[-] NO PID" && return -1
    [ ! -d lib ] && echo "[-] NO LIB FOLDER FOUND" && return -1
    find lib/ -name '*.dart' | entr -d -p kill -USR1 $(cat /tmp/flutter.pid)
    sleep 0.1
  done
}

git-create-branch() {
  echo -n "Branch name?: "
  read name
  if [ -n "$name" ]; then
    git checkout -b $name
    git push --set-upstream origin $name
  fi
}

git-create-random-branch() {
  local random=$[ $RANDOM % 5000000 + 1000000 ]
  local username="miguellopez"

  git checkout main
  git pull

  git checkout -b $username-$random
  git push --set-upstream origin $username-$random
}

git-menu() {
  local cmd
  local opts=(
    "undo: git reset --soft HEAD~1"
    "fetch: git fetch -p -P"
    "main: git checkout main"
    "clean: git checkout main && git branch | grep -v 'main' | xargs -I@ git branch -D @"
    "pull: git pull"
    "push: git push"
    'datecommit: git commit -m "$(date "+%Y-%m-%d %H:%M:%S")"'
    'add: git add . && git status'
    'discard: git restore .'
    'branch-create: git-create-branch'
    'branch-random: git-create-random-branch'
    'save: git add . && git commit -m "Commit on '"'"'$(date "+%Y-%m-%d %H:%M:%S")'"'"'" && git push'
    'branch-delete: branch=$(git branch | sed "s/[ \*]//g" | fzf); git branch -D $branch'
    'tag-upload: git push --tags'
    'tag-delete: tag=$(git tag | fzf); git tag -d $tag; git push --delete origin $tag'
  )

  cmd=$(printf '%s\n' "${opts[@]}" | fzf --layout=default)
  [ -z "$cmd" ] && return 0

  echo "-> $cmd"
  eval "$(echo $cmd | cut -d ":" -f 2-100000000 | sed 's/^ *//g')"
}

git-identity() {
  select email in "miguel.lr96@gmail.com" "miguel.lopez@logalty.com"; do
    git config user.name "Miguel López Ruiz"
    git config user.email $email
    break
  done
}

java-menu() {
    local entry=$(archlinux-java status | grep "^ " | sed 's/^ *//g' |cut -d" " -f1 | fzf)
    [ -z "$entry" ] && return
    sudo archlinux-java set $entry
}

# function clipboard() {
#     if [ "$XDG_SESSION_TYPE" = "x11" ]; then
#         xclip -i -r -sel clip "$@"
#     else
#         wl-copy -n "$@"
#     fi
# }
#
# function x11config() {
#     export GDK_BACKEND=x11
#     export QT_QPA_PLATFORM=xcb
#     export CLUTTER_BACKEND=x11
#     export SDL_VIDEODRIVER=x11
#     export WINIT_UNIX_BACKEND=x11
# }
#
# function workspace-path() {
#   [ -z "$WORKSPACE" ] && return 0
#
#   local selected=$(find $WORKSPACE -mindepth 1 -type d -print | grep -v ".git" | fzf)
#
#   [ -z "$selected" ] && return 0
#
#   if [ -n "$TMUX" ]; then
#     tmux rename-window $(basename ${WORKSPACE}| tr '[:lower:]' '[:upper:]')-$(basename ${selected} | tr '[:lower:]' '[:upper:]')
#   fi
#
#   cd $selected
# }
#
# # BLUETOOTH

# # BACKUPS
# function copysec() {
#     local commands=("rsync" "borg")
#     local command=$1
#     local dst=$(echo $2 | sed 's#/*$##g')
#     local options
#     local exclude_file include_file
#     shift
#
#     [[ ! "${commands[@]}" =~ "$command" ]] && _copysec_usage "Command $command not valid." && return 1
#     [ -z "$dst" ] && _copysec_usage "Enter a valid dst" && return 1
#
#     if [ "$command" = "rsync" ]; then
#         include_file="$HOME/.config/copysec/rsync-include.conf"
#         exclude_file="$HOME/.config/copysec/rsync-exclude.conf"
#
#         options="-rav -c --delete-after --delete-excluded"
#         options+=" --exclude-from=$exclude_file --include-from=$include_file --exclude='*'"
#
#         eval "sudo rsync $options / $dst/"
#     fi
# }

notes() {
  local notedir="$HOME/Documents/Notes"
  local remote="https://gitlab.com/MLR96/notes.git"

  ! type git &>/dev/null && return -1
  ! type nvim &>/dev/null && return -1

  [ ! -d "${notedir}" ] && \
    git clone ${remote} ${notedir}

  cd ${notedir}

  [ ! -d ".git" ] && return
  git remote | grep -q . || return

  [ -n "$TMUX" ]   && tmux rename-window "NOTES"
  [ -n "$ZELLIJ" ] && zellij action rename-tab "NOTES"

  git pull
  nvim home.md tasks.md inbox.md
  if git status | grep -q 'modified\|untracked'; then
    echo "Guardando y subiendo cambios..."
    git add .
    git commit -m "Saved at $(date '+%Y-%m-%d %H:%M:%S')"
    git push
  fi
}

# ./terraform-mv from_module to_module resources
terraform-mv() {
  local from_module="$1"
  local to_module="$2"
  local resources="$3"

  [ "${from_module}" != "root" ] && from_module="module.${from_module}." || from_module=""
  [ "${to_module}" != "root" ] && to_module="module.${to_module}." || to_module=""
  [ -d "${resources}" ] && resources="${resources}/*.tf"

  eval "cat ${resources}" | grep -v "^ *#" | grep 'resource "' | cut -d" " -f 2,3 | sed 's/" "/./g' | tr -d '"' \
     | xargs -I@ echo terraform state mv ${from_module}@ ${to_module}@
}

terraform-modulizer() {
  local module_path="$1"
  local module_name="$2"

  cat ${module_path}/*.tf | grep 'resource "' | cut -d" " -f 2,3 | sed 's/" "/./g' | tr -d '"' \
     | xargs -I@ echo terraform state mv @ module.${module_name}.@
}

echo > /dev/null

