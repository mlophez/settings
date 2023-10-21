#!/usr/bin/zsh

# SHELL
alias reload="exec zsh"
alias ll="ls -lh"
alias mkdir="command mkdir -vp"

# EDITOR
alias v="nvim"
alias vi="nvim"
alias vim="nvim"
alias cc="cd \$(find . -type d -print | fzf)"
alias edit="nvim \$(find . -type f -print | fzf)"
alias e="editor"

# ZELLIJ
alias zel="zellij -s $USER"

# SSH
alias s="ssh_menu"

# ARCHLINUX
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
alias g="git"
alias gm="git_menu"
alias wk="workspace"
alias ck="workspace move"
alias git-id-personal="git config user.name 'Miguel López Ruiz' && git config user.email 'miguel.lr96@gmail.com'"
alias git-id-logalty="git config user.name 'Miguel López Ruiz' && git config user.email 'miguel.lopez@logalty.com'"

# TUNNEL
alias t="tunnel_menu"

# AWS
alias a="aws-ssm-connect"
alias as="aws-ssm-connect ssh"
alias am="aws-profile-menu"

# DOCKER PODMAN
alias docker="podman"

# KUBERNETES
alias k="kubectl --context"
alias ka="kustomize_menu apply"
alias ks="kubectl-shell-menu"
alias kl="kubectl-log-menu"
alias kp="kubectl-menu port-forward pods"
alias kt="kubectl-pod"
alias kdrain="kubectl drain --delete-emptydir-data --ignore-daemonsets --force --context"
alias k9="k9s -c pods --context"

# DRIVE
alias reload_drive="systemctl --user restart rclone@Drive.service"

##### FUNCTIONS
# SHELL
function precmd() {
  printf "\e[5 q"
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
      lsd -v --group-directories-first "$@"
    else
      command ls -v --group-directories-first --color "$@"
    fi
  else
    command ls -v --group-directories-first "$@"
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
            tmux -2 new-session -d -s $session_name -n HOME
        else
            tmux -2 new-session -d -s $session_name -n HOME
        fi
        tmux attach-session -t $session_name
    fi
}

# SETTINGS
function gic() {
    command git --git-dir=$HOME/.local/share/settings --work-tree=$HOME "$@"
}

function status-get-windows-files() {
    local windows_user_home=$(echo $PATH | grep -io -P "/mnt/c/Users/.*?/" | head -1)

    [ -z "${windows_user_home}" ] && return 0
    [ ! -d "$HOME/.config/Windows" ] && mkdir -p $HOME/.config/Windows

    cp $windows_user_home/AppData/Roaming/Code/User/settings.json \
      $HOME/.config/Windows/code-user-settings.json

    cp $windows_user_home/AppData/Roaming/Code/User/keybindings.json \
      $HOME/.config/Windows/code-user-keybindings.json

    cp $windows_user_home/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json \
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
            $HOME/.config/wezterm \
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
            $HOME/.config/k9s \
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
      #tmux split-window -v -l 30%
      #tmux select-pane -l
      #tmux resize-pane -Z
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
    #printf "\e[?2004l"
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

    #printf "\e[?2004l"
    eval "$hook ssh $(echo $entry | cut -d" " -f1)"
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

function flyway() {
  local args
  [ -d "$(pwd)/sql" ] && args="-v $(pwd)/sql:/flyway/sql"
  [ -d "$(pwd)/postgresql" ] && args="-v $(pwd)/postgresql:/flyway/sql"
  [ -d "$(pwd)/postgres" ] && args="-v $(pwd)/postgres:/flyway/sql"

  eval podman run --rm --network=host $args docker.io/flyway/flyway "$@"
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

# NOTES
function notes() {
  cd $HOME/Documents/Notes
  [ -n "$TMUX" ]   && tmux rename-window "NOTES"
  [ -n "$ZELLIJ" ] && zellij action rename-tab "2# NOTES"
  nvim inbox.md
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

