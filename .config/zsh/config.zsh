#!/usr/bin/zsh

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
      command lsd -v --group-directories-first "$@"
    elif type exa &>/dev/null; then
      command exa --group-directories-first "$@"
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

function kubectl() {
  local cmd="kubectl"
  local extra_args

  #[ -n "$(echo "$@" | grep -e ' -f ' -e ' -k ')" ] && extra_args="--server-side"
  type kubecolor &>/dev/null && cmd="kubecolor"

  command $cmd "$@" $extra_args
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
# function workspace() {
#   local wpath selected
#
#   if [ -z "$1" ]; then
#     wpath=($(find $HOME -maxdepth 2 -iname Projects -type d -print | tr '\n' ' '))
#     selected=$(find $wpath -mindepth 1 -maxdepth 1 -type d,l -print | fzf)
#     [ -z "$selected" ] && return 0
#     cd $selected
#
#     export WORKSPACE=$(pwd)
#
#     if [ -n "$TMUX" ]; then
#       tmux rename-window $(basename ${selected} | tr '[:lower:]' '[:upper:]')
#       #tmux split-window -v -l 30%
#       #tmux select-pane -l
#       #tmux resize-pane -Z
#     fi
#
#     if [ -n "$ZELLIJ" ]; then
#       zellij action rename-tab $(basename ${selected} | tr '[:lower:]' '[:upper:]')
#     fi
#     nvim
#   else
#     selected=$(find $(pwd) -mindepth 1 -maxdepth 10 -type d,l -print | fzf)
#     [ -z "$selected" ] && return 0
#     cd $selected
#
#     export WORKSPACE=$(pwd)
#   fi
#
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
# function bluetooth_menu() {
#     [ "$(systemctl is-active bluetooth.service)" = "inactive" ] && sudo systemctl start bluetooth.service
#
#     device=$(bluetoothctl devices | fzf)
#     [ -z "$device" ] && return -1
#
#     bluetoothctl power on
#     bluetoothctl connect "$(echo $device | cut -d' ' -f 2)"
# }
#
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
#
