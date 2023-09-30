#!/usr/bin/zsh

##### ALIAS

# SHELL
alias reload="exec zsh"
alias ll="ls -lh"
alias mkdir="command mkdir -vp"

alias info="notify-send -u low -t 3000"
alias warn="notify-send -u normal -t 3000"
alias critical="notify-send -u critical -t 3000"

alias server-up="wol 00:4e:01:c5:bb:49"
alias server-ssh="sshn root@192.168.1.230"
alias server-tunnel="ssh -N -D5555 root@192.168.1.230"

alias awslogin="aws sso login --sso-session awscli"

# TMUX
alias tmux="command tmux -f $HOME/.config/tmux/tmux.conf"

# ZELLIJ
alias zel="zellij"

# ZSH
alias config="nvim $HOME/.config/zsh/config.zsh"
alias config-zsh="nvim $HOME/.config/zsh/.zshrc"
alias config-env="nvim $HOME/.config/zsh/.zshenv"
alias config-nvim="cd $HOME/.config/nvim && nvim; cd"
alias config-tmux="nvim $HOME/.config/tmux/tmux.conf"

# EDITOR
alias v="nvim"
alias vi="nvim"
alias vim="nvim"
alias cc="cd \$(find . -type d -print | fzf)"
alias edit="nvim \$(find . -type f -print | fzf)"
alias e="editor"

# SSH
alias ssh_config="nvim $HOME/.ssh/config"
alias s="ssh_menu"

# NOTES
alias notes="cd $HOME/Documents/Notes && tmux rename-window NOTES && nvim inbox.md"

# SYSTEM
alias install="sudo pacman --needed -S"
alias uninstall="sudo pacman -Rns"
alias update="sudo reflector --verbose --latest 20 --sort rate --protocol https --save /etc/pacman.d/mirrorlist"
alias upgrade="sudo pacman -Syu; type yay &> /dev/null && yay -Syua; sudo pacman -Scc"

# WIFI
alias wifi-on="nmcli radio wifi on"
alias wifi-off="nmcli radio wifi off"
alias wifi-list="wifi-on && nmcli device wifi list"
alias wifi-connect="nmcli device wifi connect --ask"
alias wifi-show="nmcli connection show"
alias wifi-up="nmcli connection up"
alias wifi-down="nmcli connection down"

# AUDIO
alias audio-hdmi="pactl set-card-profile 0 output:hdmi-stereo-extra1"
alias audio-micro="pactl set-card-profile 0 output:analog-stereo+input:analog-stereo"

# ANSIBLE
alias playbook="ansible-playbook"
alias inventory="ansible-inventory"

# GIT
alias g="git_menu"
alias wk="workspace"
alias ck="workspace move"
alias git-config-logalty="git config user.email 'miguel.lopez@logalty.com'"

# AWS
alias a="aws-ssm-connect"
alias as="aws-ssm-connect ssh"
alias am="aws-profile-menu"

# DOCKER PODMAN
alias docker="podman"

# KUBERNETES
alias k="kubectl-wrapper --context"
alias ka="kubectl apply --server-side --context"
alias kd="kubectl delete --ignore-not-found=true --context"
alias ks="kubectl-shell-menu"
alias kl="kubectl-log-menu"
alias kp="kubectl-menu port-forward pods"
alias kt="kubectl-pod"
alias krun="echo kubectl --context demo run ubuntu -it --rm --image=ubuntu:latest --restart=Never -- bash"
alias kdrain="kubectl drain --delete-emptydir-data --ignore-daemonsets --force --context"
#alias apply="kubectl apply --server-side"
#alias delete="kubectl delete"
#alias kc="kubectl-context"

# DISTROBOX
alias archlinux='eval $(distrobox enter archlinux --dry-run -- bash)'
alias archlinux-install="sudo pacman --needed -S $(cat $HOME/.config/distrobox/Packages.Archlinux | grep -v "^ *#" | grep -v "^ *$" | tr "\n" " ")"

# DRIVE
alias reload_drive="systemctl --user restart rclone@Drive.service"

##### FUNCTIONS
# SHELL
function precmd() {
  # Underscore blinking # printf "\e[5 q" # Vertical Line }
  # printf "\e[3 q"
  #printf "\e]12;red\x7;\e[5 q"
  printf "\e[5 q"
  # if [ -n "$TMUX" ]; then
  #   if [ -d "./.git" ]; then
  #     tmux rename-window $(basename $(pwd) | tr '[:lower:]' '[:upper:]')
  #   fi
  # fi
}

function timezsh() {
  local shell=${1-$SHELL}
  local i
  for i in $(seq 1 10); do time $shell -i -c exit; done
}

function ls() {
  local afunctrace=($functrace) 
  if [[ ${#afunctrace[@]} -le 1 ]]; then
    if type lsd &>/dev/null; then
      lsd "$@"
    else
      command ls -v --color "$@"
    fi
  else
    command ls -v "$@"
  fi
}

function cat() {
  if type bat &>/dev/null; then
    bat "$@"
  else
    command cat "$@"
  fi
}

function clipboard() {
    if [ "$XDG_SESSION_TYPE" = "x11" ]; then
        xclip -i -r -sel clip "$@"
    else
        wl-copy -n "$@"
    fi
}

function x11config() {
    export GDK_BACKEND=x11
    export QT_QPA_PLATFORM=xcb
    export CLUTTER_BACKEND=x11
    export SDL_VIDEODRIVER=x11
    export WINIT_UNIX_BACKEND=x11
}

# TMUX
function tm() {
    local session_name=$1
    [ -z "$session_name" ] && session_name=$USER

    if [ -n "$(tmux ls 2>/dev/null | grep $session_name:)" ]; then
        tmux attach-session -t $session_name
    else
        if [ "$session_name" = "$USER" ]; then
            #tmux start-server
            tmux -2 new-session -d -s $session_name -n LOCAL
        else
            tmux -2 new-session -d -s $session_name -n LOCAL
        fi
        tmux attach-session -t $session_name
    fi
}

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
    'datecommit: git commit -m "$(date "+%Y-%m-%d %H:%M:%S")"'
    'add: git add . && git status'
    'discard: git restore .'
    'branch-create: git_branch_create'
    'branch-random: git_generate_random_branch'
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

function git_generate_random_branch() {
  local random=$[ $RANDOM % 5000000 + 1000000 ]
  local username="miguellopez"

  git checkout main
  git pull

  git checkout -b $username-$random
  git push --set-upstream origin $username-$random
}

function git_branch_create() {
  echo -n "Branch name?: "
  read name
  if [ -n "$name" ]; then
    git checkout -b $name
    git push --set-upstream origin $name
  fi
}

function workspace() {
  local wpath selected

  if [ -z "$1" ]; then
    wpath=($(find $HOME -maxdepth 2 -iname Projects -type d -print | tr '\n' ' '))
    selected=$(find $wpath -mindepth 1 -maxdepth 1 -type d,l -print | fzf)
    [ -z "$selected" ] && return 0
    cd $selected
    
    export WORKSPACE=$(pwd)

    if [ -n "$TMUX" ]; then
      tmux rename-window $(basename ${selected} | tr '[:lower:]' '[:upper:]')
      tmux split-window -v -l 30%
      tmux select-pane -l
      tmux resize-pane -Z
    fi

    if [ -n "$ZELLIJ" ]; then
      zellij action rename-tab $(basename ${selected} | tr '[:lower:]' '[:upper:]')
    fi
    nvim
  else
    selected=$(find $(pwd) -mindepth 1 -maxdepth 10 -type d,l -print | fzf)
    [ -z "$selected" ] && return 0
    cd $selected

    export WORKSPACE=$(pwd)
  fi

}

function editor() {
  if [ -n "$TMUX" ]; then
    tmux split-window -v -l 30%
    tmux select-pane -U
    tmux send-keys nvim Enter
  fi
}

function workspace-path() {
  [ -z "$WORKSPACE" ] && return 0

  local selected=$(find $WORKSPACE -mindepth 1 -type d -print | grep -v ".git" | fzf)

  [ -z "$selected" ] && return 0

  if [ -n "$TMUX" ]; then
    tmux rename-window $(basename ${WORKSPACE}| tr '[:lower:]' '[:upper:]')-$(basename ${selected} | tr '[:lower:]' '[:upper:]')
  fi

  cd $selected
}


# SSH
function ssh() {
  printf "\e[?2004l"
  command ssh "$@"
}

function ssh-legacy() {
    export TERM=xterm-256color
    printf "\e[?2004l"
    command ssh -oKexAlgorithms=+diffie-hellman-group1-sha1 $@
}

function ssh_menu() {
    local entries entry
    local profile hook

    entries=$(cat $HOME/.ssh/config | grep -i "^Host" | grep -v "*" | sed 's/ \+/ /g' | cut -d" " -f2-100000 | sort)
    entry=$(printf "$entries" | fzf)
    [ -z "$entry" ] && return 

    # Password
    if [ -e $HOME/.ssh/credentials ]; then
      profile=$(cat $HOME/.ssh/credentials | cut -d'|' -f 1 | fzf)
      if [ -n "$profile" -a "${profile}" != "NONE" ];  then
        hook="sshpass -p'$(cat $HOME/.ssh/credentials | grep ^$profile | cut -d'|' -f 2)'"
      fi
    fi

    echo "[+] Connect to '$(echo $entry | cut -d" " -f1)'"

    printf "\e[?2004l"
    eval "TERM=xterm-256color $hook ssh $(echo $entry | cut -d" " -f1)"
}

function docker-upload-image () {
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

# KUBERNETES
function kubectl-wrapper() {
  local cmd="kubectl"
  local extra_args

  #[ -n "$(echo "$@" | grep -e ' -f ' -e ' -k ')" ] && extra_args="--server-side"
  type kubecolor &>/dev/null && cmd="kubecolor"

  command $cmd "$@" $extra_args
}

function kubectl-context() {
  local context

  context=$(kubectl config get-contexts -o name | fzf)
  [ -z "$context" ] && return 0

  sed "s/current-context:.*$/current-context: $context/g" -i $KUBECONFIG
}

function kvalidator() {
  echo "***** KUBE-SCORE *****"

  kustomize build . --enable-helm | kube-score score \
    --kubernetes-version "v1.26" \
    --ignore-container-cpu-limit \
    --ignore-container-memory-limit \
    --ignore-test "pod-networkpolicy" \
    --ignore-test "container-ephemeral-storage-request-and-limit" \
    -

  echo "***** KUBEVAL *****"
  kustomize build . --enable-helm | kubeval --ignore-missing-schemas --strict || return 0
}

function kbuild() {
  local target="$1"; shift
  [ -z "$target" ] && echo "Especify target" && return 1

  kustomize build "$target" --enable-helm
}

function kdiff() {
  local target="$1"; shift
  [ -z "$target" ] && echo "Especify target" && return 1
  kustomize build "$target" --enable-helm | kubectl diff --server-side "$@" -f -
}

function kapply() {
  local target="$1"; shift
  [ -z "$target" ] && echo "Especify target" && return 1
  [ -d "$target/charts" ] && rm -rf "$target/charts" &>/dev/null

  kustomize build "$target" --enable-helm | kubectl apply --server-side "$@" -f -
}

function kdelete() {
  local target="$1"; shift
  [ -z "$target" ] && echo "Especify target" && return 1
  kustomize build "$target" --enable-helm | kubectl delete --ignore-not-found=true "$@" -f -
}


function kfolder() {
  local folder="$1"

  if [ -z "$folder" ]; then
    for folder in $(find $(pwd) -maxdepth 1 -mindepth 1 -type d); do
      [ ! -d "$folder/base" ] && mkdir -p $folder/base &>/dev/null
      mv $folder/*.* $folder/base/ &> /dev/null
    done
  else
      [ ! -d "$folder/base" ] && mkdir -p $folder/base &>/dev/null
      [ ! -d "$folder/overlays/default" ] && mkdir -p $folder/overlays/default &>/dev/null
      mv $folder/*.* $folder/base/ &> /dev/null
      cat << EOF > $folder/overlays/default/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - ../../base
EOF
  fi
}

function kubeenc() {
  local password="$1"

  echo "kubeseal --raw --scope cluster-wide"
  echo -n "$password" | kubeseal --raw --scope cluster-wide

  # local context=$(basename $(pwd))
  # if [ -z "$(kubectl config get-contexts -o name | grep "$context")" ]; then
  #   echo "kubeseal --raw --scope cluster-wide"
  #   echo -n "$password" | kubeseal --raw --scope cluster-wide
  # else
  #   echo "kubeseal --context=$context --raw --scope cluster-wide"
  #   echo -n "$password" | kubeseal --context=$context --raw --scope cluster-wide
  # fi
}

function kustomize-helm() {
  local chart="$1"
  local version="$2"
  local name="$3"
  local repo

  # # ADD REPO IF NOT EXISTS
  # [ -z "$(helm repo list -o table | grep -i "$repo_name" | grep -i "$repo_url")" ] && \
  #   helm repo add $repo $repo_name

  # # UPDATE REPOSITORY
  # helm repo update $repo_name --fail-on-repo-update-fail

  # GET VERSIONS
  [ -z "$version" ] && \
    helm search repo $chart --versions -o table | head -10 && return 0
    #helm search repo $chart --versions -o json | jq -r '.[].version' | head -5 && return 0

  shift; shift; shift

  # GET DEFAULTS VALUES
  [ ! -e "${name}-values-${version}.yaml" ] && \
    helm show values ${chart} --version ${version} | tee ${name}-values-${version}.yaml ${name}-default-values-${version}.yaml

  # GET BUNDLE FILE
  helm template ${name} ${chart} \
    --include-crds \
    --skip-tests \
    --values $name-values-$version.yaml \
    --version $version "$@" \
    | grep -v -e "app\.kubernetes\.io/managed-by: Helm" -e "helm.sh/.*:" > ${name}-bundle-${version}.yaml
    #--namespace kube-ingress
}

function kinfo() {
    local namespace="$1"
    clear

    if [ -z "$namespace" ]; then
        kubectl get all -o wide
        echo
        kubectl get ing -o wide
    else
        kubectl -n $namespace get all -o wide
        echo
        kubectl -n $namespace get ing -o wide
    fi
}

function kubernetes-clean-terminated-pods() {
  local context="$1"
  local namespace
  local pod

  [ -z "$context" ] && echo "$0 <context>" && return -1

  for i in $(kubectl --context ${context} get pods -A | grep 'Terminating' | awk '{print $1 ":" $2}'); do
    pod=$(echo $i | cut -d":" -f2)
    namespace=$(echo $i | cut -d":" -f1)
    kubectl --context ${context} -n ${namespace} delete pod --force --grace-period=0 ${pod}
  done
  
}

# SETTINGS
function gic() {
    command git --git-dir=$HOME/.local/share/settings --work-tree=$HOME "$@"
}

function status-get-windows-files() {
    [ ! -d "$HOME/.config/Windows" ] && mkdir -p $HOME/.config/Windows

    cp $WSLHOME/AppData/Roaming/Code/User/settings.json \
      $HOME/.config/Windows/code-user-settings.json

    cp $WSLHOME/AppData/Roaming/Code/User/keybindings.json \
      $HOME/.config/Windows/code-user-keybindings.json

    cp $WSLHOME/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json \
      $HOME/.config/Windows/terminal-settings.json
}

function status() {
    gic restore --staged . &>/dev/null

    status-get-windows-files

    [ -e "$KUBECONFIG" ] && \
      sed "s/current-context:.*$/current-context: none/g" -i $KUBECONFIG

    gic add $HOME/.config/zsh \
            $HOME/.config/nvim \
            $HOME/.config/tmux \
            $HOME/.config/zellij \
            $HOME/.config/alacritty \
            $HOME/.config/git \
            $HOME/.config/kube/config \
            $HOME/.config/wsl \
            $HOME/.config/qtile \
            $HOME/.config/waybar \
            $HOME/.config/sway \
            $HOME/.config/mutt \
            $HOME/.config/systemd \
            $HOME/.config/mako \
            $HOME/.config/zsh \
            $HOME/.config/containers \
            $HOME/.config/distrobox \
            $HOME/.config/i3 \
            $HOME/.config/gnupg \
            $HOME/.config/Windows \
            $HOME/.config/Code/User/settings.json \
            $HOME/.config/Code/User/keybindings.json \
            $HOME/.local/share/codews \
            $HOME/.local/share/fonts \
            $HOME/.ssh/config \
            $HOME/.aws/config \
            $HOME/.bashrc \
            $HOME/.gitignore

    gic status
}

function save() {
    gic commit -m "Commit on '$(date '+%Y-%m-%d %H:%M:%S')'"
    gic push -u origin main
}

function load() {
    gic pull
}

function wsl-install() {
    #[ "$(whoami)" != "root" ] && echo "Run as a root" && return -1

    sudo bash <<EOF
apt install zsh tmux neovim fzf unzip

curl -sLo /tmp/win32yank.zip https://github.com/equalsraf/win32yank/releases/download/v0.0.4/win32yank-x64.zip
unzip -p /tmp/win32yank.zip win32yank.exe > /usr/local/bin/win32yank.exe
chmod +x /usr/local/bin/win32yank.exe
EOF
}

function wsl-configure() {
  cat $HOME/.config/wsl/wslconfig > $WSLHOME/.wslconfig
  sudo bash <<EOF
cat $HOME/.config/wsl/wsl.conf > /etc/wsl.conf
cat $HOME/.config/wsl/wslboot.sh > /usr/local/bin/wslboot
chmod 755 /usr/local/bin/wslboot
EOF
}

# PASS
function pass {
    local commands=("init" "ls" "grep" "find" "show" "insert" "edit" "generate" "rm" "mv" "cp" "git" "otp")
    local args=("${@[@]}")
    local pos=()
    local clip=false
    local rc

    while [[ $# -gt 0 ]]; do
        case $1 in
            -c|--clip)
                clip=true
                shift
                ;;
            -*)
                shift
                ;;
            *)
                pos+=("$1")
                shift
                ;;
        esac
    done

    set -- "${args[@]}"
    
    if [[ "$1" = "list" ]]; then
        find $PASSWORD_STORE_DIR -type f,l -name \*.gpg | sed "s#$PASSWORD_STORE_DIR/*##g" | sed 's/\.gpg$//g'
    elif [[ "${commands[@]}" =~ "$1" ]]; then
        command pass "$@"
    else
        if [ -z "$pos[2]" ]; then
            command pass "$@"
        else
            if [ "$pos[2]" = "password" ]; then
                rc=$(pass "$pos[1]" | head -1)
                [ -z "$rc" ] && return 1
                [ "$clip" = "true" ] && echo $rc | clipboard && return 0
                echo $rc
            elif [ "$pos[2]" = "otpauth" ] || [ "$pos[2]" = "otp" ]; then
                if [ "$clip" = "true" ]; then
                    command pass otp -c "$pos[1]"
                else
                    command pass otp "$pos[1]"
                fi
            else
                rc=$(pass "$pos[1]" | grep "^$pos[2]:" | sed "s/^$pos[2]: *//g" | tr '\n' ' ' | sed 's/ *$//g')
                [ -z "$rc" ] && return 1
                [ "$clip" = "true" ] && echo $rc | clipboard && return 0
                echo $rc
            fi
        fi
    fi
}

function pass_menu() {
    local entries=$(pass list)
    local entry=$(printf "$entries" | fzf)
    [ -z "$entry" ] && return 

    eval "pass $entry"
}

function pass_menu_edit() {
    local entries=$(pass list)
    local entry=$(printf "$entries" | fzf)
    [ -z "$entry" ] && return 

    eval "pass edit $entry"
}

# Grupo,Titulo,Usuario,Contraseña,URL,Notas,OTP
function pass2csv() {
    local group title user password url notes otp
    for i in $(pass list); do
        group=$(dirname $i | tr '[:lower:]' '[:upper:]')
        title=$(basename $i | tr '[:lower:]' '[:upper:]')
        user=$(pass $i user 2> /dev/null)
        password=$(pass $i password 2> /dev/null)
        url=$(pass $i url 2> /dev/null)
        otp=$(pass $i | grep ^otpauth 2> /dev/null)
        notes=$(pass $i | tr '\n' ' ')

        [ "$group" = "." ] && group="ROOT"

        echo "|$group|,|$title|,|$user|,|$password|,|$url|,|$notes|,|$otp|"

        #break
    done
}

# JAVA
function java_menu() {
    local entry=$(archlinux-java status | grep "^ " | sed 's/^ *//g' |cut -d" " -f1 | fzf)
    [ -z "$entry" ] && return 
    sudo archlinux-java set $entry
}

# BLUETOOTH
function bluetooth_menu() {
    [ "$(systemctl is-active bluetooth.service)" = "inactive" ] && sudo systemctl start bluetooth.service

    device=$(bluetoothctl devices | fzf)
    [ -z "$device" ] && return -1

    bluetoothctl power on
    bluetoothctl connect "$(echo $device | cut -d' ' -f 2)"
}

# BACKUPS
function copysec() {
    local commands=("rsync" "borg")
    local command=$1
    local dst=$(echo $2 | sed 's#/*$##g')
    local options
    local exclude_file include_file
    shift

    [[ ! "${commands[@]}" =~ "$command" ]] && _copysec_usage "Command $command not valid." && return 1
    [ -z "$dst" ] && _copysec_usage "Enter a valid dst" && return 1

    if [ "$command" = "rsync" ]; then
        include_file="$HOME/.config/copysec/rsync-include.conf"
        exclude_file="$HOME/.config/copysec/rsync-exclude.conf"

        options="-rav -c --delete-after --delete-excluded"
        options+=" --exclude-from=$exclude_file --include-from=$include_file --exclude='*'"

        eval "sudo rsync $options / $dst/"
    fi
}

# NOTES
# function notes() {
#   local notespath="$HOME/Documents/Wiki"
#   local repository=""
# 
#   [ "$notespath/pages" ] && mkdir -p "$notespath/pages" &>/dev/null
#   [ "$notespath/assets" ] && mkdir -p "$notespath/assets" &>/dev/null
# 
#   [ -n "$TMUX" ] && tmux rename-window 'NOTES'
# 
#   # Run NeoVim
#   cd $notespath
#   [ -d ".git/" ] && git pull
#   nvim index.md
#   [ -d ".git/" ] && git status
# 
#   # Save changes
#   #[ -n "$(git status | grep -i untracked)" ] && \
#   #[ -d ".git/" ] && \
#   #  git add . && \
#   #  git commit -m "$(date '+%Y-%m-%d %H:%M:%S')" && \
#   #  git push -u origin main
# }

function aws-profile-menu() {
  local profile="$(cat $HOME/.aws/config | grep -v "^ *#" | grep -o "\[ *profile .*\]" | sed 's/\]//g' | cut -d" " -f 2 | fzf)"
  [ -z "$profile" ] && return 0
  export AWS_PROFILE="$profile"
}

function aws-inventory() {
  local regions=("eu-west-1" "eu-south-2")
  local profiles=($(cat $HOME/.aws/config | grep -v "^ *#" | grep -o "\[ *profile .*\]" | sed 's/\]//g' | cut -d" " -f 2 | grep -v root |tr "\n" ' '))
  local query='.Reservations[] | .Instances[] | select(.State.Name != "terminated") | { Name: (.Tags[]|select(.Key=="Name")|.Value), InstanceId: .InstanceId, Region: $region, Profile: $profile } | join (";") '
  local region profile

  [ ! -d "$HOME/.aws" ] && mkdir -p $HOME/.aws

  # INVENTORY FILE
  cat /dev/null > $HOME/.aws/inventory
  for profile in $profiles; do
    for region in $regions; do
      aws ec2 describe-instances --region $region --profile $profile | \
        jq --arg region "$region" --arg profile "$profile" -r "$query" >> $HOME/.aws/inventory
    done
  done
}

function aws-ssm-connect() {
  local instance
  local instance_name instance_id region profile

  instance=$(cat $HOME/.aws/inventory | column -s ';' -t | fzf )
  [ -z "$instance" ] && return 0

  echo "$instance" | awk '{ print $1 }'

  instance_name=$(echo "$instance" |  awk '{print $1 }')
  instance_id=$(echo "$instance" |  awk '{print $2 }')
  region=$(echo "$instance" |  awk '{print $3 }')
  profile=$(echo "$instance" |  awk '{print $4 }')

  echo "-> Connect to ${instance_id} - ${instance_name}"
  echo "aws ssm start-session --target ${instance_id} --region ${region} --profile ${profile}" --cli-read-timeout 8000

  if [ -z "$1" ]; then
    eval ssh ${instance_id} -o ProxyCommand=\"aws ssm start-session --target ${instance_id} \
      --document-name AWS-StartSSHSession --parameters 'portNumber=22' \
      --region ${region} --profile ${profile}\"
  else
    eval aws ssm start-session --target ${instance_id} --region ${region} --profile ${profile}
  fi

  #ProxyCommand aws ssm start-session --target %h --document-name AWS-StartSSHSession --parameters 'portNumber=%p' --profile logalty
  # aws ssm start-session --target "Your Instance ID" --document-name AWS-StartPortForwardingSession --parameters "portNumber"=["80"],"localPortNumber"=["56789"]
}

function kubectl-get-all {
  local context="${1}"
  local namespace="${2}"

  for i in $(kubectl --context=${context} api-resources --verbs=list --namespaced -o name | grep -v "events.events.k8s.io" | grep -v "events" | sort | uniq); do
    echo "Resource:" $i
    echo 
    kubectl --context=${context} -n ${namespace} get --ignore-not-found ${i}
    echo ---
  done

}

function kubectl-shell-menu() {
  local context="$1"
  local instance pod namespace
  local datafile=$(mktemp)

  [ -z "$context" ] && echo "kubectl-shell-menu <context>" && return -1

  kubectl --context $context get pods -A -o template --template='{{range .items}}{{.metadata.name}}{{";"}}{{.metadata.namespace}}{{"\n"}}{{end}}' > $datafile

  instance=$(cat $datafile | column -s ';' -t | fzf)
  [ -z "$instance" ] && return 0

  pod=$(echo "$instance" | awk '{print $1 }')
  namespace=$(echo "$instance" | awk '{print $2 }')

  #kubectl --context $context -n $namespace exec -it $pod -- sh -c "(bash || ash || sh)"
  print -z kubectl --context $context -n $namespace exec -it $pod -- sh -c "'(bash || ash || sh)'"
}

function kubectl-log-menu() {
  local context="$1"
  local instance pod namespace
  local datafile=$(mktemp)

  [ -z "$context" ] && echo "kubectl-shell-menu <context>" && return -1

  kubectl --context $context get pods -A -o template --template='{{range .items}}{{.metadata.name}}{{";"}}{{.metadata.namespace}}{{"\n"}}{{end}}' > $datafile

  instance=$(cat $datafile | column -s ';' -t | fzf)
  [ -z "$instance" ] && return 0

  pod=$(echo "$instance" | awk '{print $1 }')
  namespace=$(echo "$instance" | awk '{print $2 }')
  regex="$(echo $pod | sed 's/-[a-z0-9]\+$//g')-"
  #regex="$(echo $pod | sed 's/-[a-z0-9]\+-[a-z0-9]\+$//g')-"

  if type stern &>/dev/null; then
    print -z stern --context ${context} -n ${namespace} ${regex}
    #stern --context ${context} -n ${namespace} ${regex}
  else
    print -z kubectl --context $context -n $namespace logs -f pod/$pod
    #kubectl --context $context -n $namespace logs -f pod/$pod
  fi
}

# alias df=kubectl-menu port-forward pods
function kubectl-menu() {
  local verb="$1"
  local objects="$2"
  local context="$3"
  local datafile=$(mktemp)
  local instance object namespace

  [ -z "$context" ] && echo "kubectl-menu <context> <verb> <objects>" && return -1

  kubectl --context $context get ${objects} -A -o template --template='{{range .items}}{{.metadata.name}}{{";"}}{{.metadata.namespace}}{{"\n"}}{{end}}' > $datafile

  instance=$(cat $datafile | column -s ';' -t | fzf)
  [ -z "$instance" ] && return 0

  object=$(echo "$instance" | awk '{print $1 }')
  namespace=$(echo "$instance" | awk '{print $2 }')

  print -z "kubectl --context ${context} -n ${namespace} ${verb} ${objects}/${object}"
}

function kubectl-pod() {
  local context="$1"
  local image="${2:-ubuntu:latest}"

  [ -z "$context" ] && echo "kubectl-pod <context> <image:default=ubuntu:latest>" && return -1

  kubectl --context ${context} run pod-${USER}-$(echo $RANDOM | md5sum | head -c 10) -it --rm --image=${image} --restart=Never -- sh -c "clear; (bash || ash || sh)"
}

function eks-volume-delete() {
  local context="$1"
  local temp=$(mktemp)
  local template='{{ range .items }}{{ .status.phase }} {{ .metadata.name }} {{ .spec.claimRef.name }} {{ .spec.csi.driver }} {{ .spec.csi.volumeHandle }}{{ "\n" }}{{ end }}'

  [ -z "$context" ] && echo "kubectl-menu <context> <verb> <objects>" && return -1

  #kubectl --context ${context} get pv | grep -i Released > $temp
  kubectl --context ${context} get pv -o template --template="$template" | grep -i '^Released' | column -t > $temp

  local pvo=$(cat $temp | fzf)
  local pv="$(echo $pvo | awk '{print $2}')"
  local fs="$(echo $pvo | awk '{print $5}' | grep -o 'fs-[a-z0-9]*')"
  local ap="$(echo $pvo | awk '{print $5}' | grep -o 'fsap-.*$')"

  [ -z "$pv" ] && return 0
  [ -z "$fs" ] && return 0

  echo "Filesystem: ${fs}"
  echo "Deleting volume pv: $pv"
  echo "Deleting access point: $ap"
  echo

  kubectl --context ${context} delete pv ${pv}
  aws efs delete-access-point --access-point-id ${ap} --profile ${context}

  # Erase filesystem
  local podname="volume-delete"
  local override="{\"spec\":{\"containers\":[{\"name\": \"${podname}\", \"volumeMounts\":[{\"name\":\"storage\",\"mountPath\":\"/data\"}]}],\"volumes\":[{\"name\":\"storage\",\"nfs\":{\"server\":\"${fs}.efs.eu-south-2.amazonaws.com\",\"path\":\"/\"}}]}}"

  kubectl --context ${context} run ${podname} -i --rm --image=ubuntu --restart=Never --override-type=strategic --overrides="${override}" -- bash -c "ls -lh /data/${pv}/ ; while [ -d '/data/${pv}' ]; do rm -I -r /data/${pv}/; done"
}

