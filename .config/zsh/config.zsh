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

# ZSH
alias config="nvim $HOME/.config/zsh/config.zsh"
alias config-zsh="nvim $HOME/.config/zsh/.zshrc"
alias config-env="nvim $HOME/.config/zsh/.zshenv"
alias config-nvim="cd $HOME/.config/nvim && nvim; cd"
alias config-tmux="nvim $HOME/.config/tmux/tmux.conf"

# EDITOR
alias vi="nvim"
alias vim="nvim"
alias cc="cd \$(find . -type d -print | fzf)"
alias edit="nvim \$(find . -type f -print | fzf)"

# SSH
alias ssh_config="nvim $HOME/.ssh/config"
alias s="ssh_menu"

# NOTES
alias notes="cd $HOME/Documents/Wiki && tmux rename-window NOTES && nvim index.md"

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
alias git-config-logalty="git config user.email 'miguel.lopez@logalty.com'"

# AWS
alias a="aws-ssm-connect"
alias as="aws-ssm-connect ssh"
alias am="aws-profile-menu"

# DOCKER PODMAN
alias docker="podman"
alias podman="distrobox-host podman"
alias flatpak="distrobox-host flatpak"
alias distrobox="distrobox-host distrobox"
alias systemctl="distrobox-host systemctl"
alias microk8s="distrobox-host microk8s"
alias se="service"
alias infracost="docker run --rm -e INFRACOST_API_KEY=$(cat $HOME/.local/share/vault/infracost-api-key) -v $HOME:$HOME -w $(pwd) infracost/infracost:ci-latest"

# KUBERNETES
alias k="kubectl"
alias kc="kubectl-context"
alias apply="kubectl apply -k"
alias delete="kubectl delete -k"

# DISTROBOX
alias archlinux="distrobox-archlinux"
alias archlinux-install="sudo pacman --needed -S $(cat $HOME/.config/distrobox/Packages.Archlinux | grep -v "^ *#" | grep -v "^ *$" | tr "\n" " ")"

# DRIVE
reload_drive="systemctl --user restart rclone@Drive.service"

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
      lsd -v "$@"
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
        exec tmux attach-session -t $session_name
    else
        if [ "$session_name" = "$USER" ]; then
            #tmux start-server
            tmux -2 new-session -d -s $session_name -n LOCAL
        else
            tmux -2 new-session -d -s $session_name -n LOCAL
        fi
        exec tmux attach-session -t $session_name
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
  local wpath=($(find $HOME -maxdepth 2 -iname Projects -type d -print | tr '\n' ' '))
  local selected=$(find $wpath -mindepth 1 -maxdepth 1 -type d,l -print | fzf)
  [ -z "$selected" ] && return 0

  [ -n "$TMUX" ] && tmux rename-window $(basename ${selected} | tr '[:lower:]' '[:upper:]')
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

    entries=$(cat $HOME/.ssh/config | grep -i "^Host" | grep -v "*" | sed 's/ \+/ /g' | cut -d" " -f2-100000 | sort)
    entry=$(printf "$entries" | fzf)
    [ -z "$entry" ] && return 

    echo "[+] Connect to '$(echo $entry | cut -d" " -f1)'"

    printf "\e[?2004l"
    eval "TERM=xterm-256color ssh $(echo $entry | cut -d" " -f1)"
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
  if [ -z "$(distrobox list --no-color  | grep archlinux)" ]; then
    distrobox-create -i docker.io/archlinux:latest -n archlinux
  fi
  exec distrobox enter archlinux -- bash
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
function kubectl() {
  if type kubecolor &>/dev/null; then
    command kubecolor "$@"
  else
    command kubectl "$@"
  fi
}

function kubectl-context() {
  local context

  context=$(kubectl config get-contexts -o name | fzf)
  [ -z "$context" ] && return 0

  sed "s/current-context:.*$/current-context: $context/g" -i $KUBECONFIG
}

function kubeenc() {
  local password="$1"

  local context=$(basename $(pwd))
  if [ -z "$(kubectl config get-contexts -o name | grep "$context")" ]; then
    echo "kubeseal --raw --scope cluster-wide"
    echo -n "$password" | kubeseal --raw --scope cluster-wide
  else
    echo "kubeseal --context=$context --raw --scope cluster-wide"
    echo -n "$password" | kubeseal --context=$context --raw --scope cluster-wide
  fi
}

function helm-template() {
  local name="$1"
  local repo="$2"
  local version

  version="$(helm search repo $repo | grep -v "^NAME" | head -1 | awk '{ OFS = "_" } {print $2,$3}')"
  
  echo "Version: $version"
  [ ! -e ${name}-${version}.values.yaml ] && helm show values $repo > ${name}-${version}.values.yaml
  helm template $name $repo -f ${name}-${version}.values.yaml --include-crds --skip-tests --release-name > ${name}-${version}.yaml
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
            $HOME/.local/share/applications/archlinux.desktop \
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
  echo "aws ssm start-session --target ${instance_id} --region ${region} --profile ${profile}"

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

