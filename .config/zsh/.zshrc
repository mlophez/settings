#!/usr/bin/zsh

# zmodload zsh/zprof

#### SETTINGS
HISTSIZE=10000
SAVEHIST=10000
HISTFILE="$HOME/.zhistory"
HISTIGNORE='pass *'
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

umask 077

typeset -U path
typeset -U fpath

autoload -U colors && colors
autoload -U compinit && compinit
autoload -Uz promptinit && promptinit
autoload -U select-word-style && select-word-style bash
zstyle 'completion:*' menu select
#emulate sh

# Auto completion options
setopt autocd			# Imply cd when directory path is supplied
setopt automenu			# Automatically use menu completion on 2nd tab
setopt menucomplete		# Cycle though autocomplete options

# History options
setopt appendhistory	# Append history file rather than replace it
setopt extendedhistory	# Save each commands time stamp
setopt histfindnodups	# Ignore duplicates when searching
setopt histignoredups	# Ignore duplicate simultaneous events
setopt histignorespace	# Ignore commands that being with space
setopt histsavenodups	# Ignore old duplicate commands on save

setopt completealiases

#### BINDKEYS
bindkey -e
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line
bindkey "^[[3~" delete-char
bindkey '^R' history-incremental-search-backward
# bindkey "\033[1~" beginning-of-line
# bindkey "\033[4~" end-of-line

# Clear screen A-h
# bindkey '\eh' clear-screen

#  # Move
#  bindkey -s '\eñ' '^[[C'
#  bindkey -s '\ej' '^[[D'
#  bindkey -s '\ek' '^[[B'
#  bindkey -s '\el' '^[[A'

#### PLUGINS
[ -e /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] && \
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

[ -e /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && \
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

[ -e /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh ] && \
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh

[ -e /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh ] && \
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh

[ -e "$HOME/.config/zsh/plugins/fzf-history-search.zsh" ] && \
    source $HOME/.config/zsh/plugins/fzf-history-search.zsh

# PROMPT
#[ ! -d "$HOME/.local/share/zsh/spaceship" ] && \
#  git clone --depth=1 https://github.com/spaceship-prompt/spaceship-prompt.git "$HOME/.local/share/zsh/spaceship"
#source ~/.local/share/zsh/spaceship/spaceship.zsh
prompt redhat
type starship &>/dev/null && eval "$(starship init zsh)"

# AUTOCOMPLETE
[[ $commands[kubectl] ]] && source <(kubectl completion zsh)

# TMUX
#[ -n "${TMUX_POPUP}" ] && setopt ignore_eof

# PYTHON
#[ -n "${PYTHONVENV}" ] && [ ! -d "${PYTHONVENV}" ] && \
#  echo "-> Creating local virtualenv for python" && command python -m venv "${PYTHONVENV}"

#[ -e ${PYTHONVENV}/bin/activate ] && \
#  source ${PYTHONVENV}/bin/activate

#[ "$PIPENV_ACTIVE" -eq 1 ] && deactivate

# NIX
#[ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ] && \
#    source $HOME/.nix-profile/etc/profile.d/nix.sh

# ALIASES
alias reload="exec zsh"
alias ll="ls -lh"
alias mkdir="command mkdir -vp"

alias v="nvim"
alias vi="nvim"
alias vim="nvim"
alias cc="cd \$(find . -type d -print | fzf)"
alias edit="nvim \$(find . -type f -print | fzf)"
alias e="editor"

# DOT
alias status="dot changes"
alias save="dot save"
alias load="dot load"

alias nvchad="NVIM_APPNAME='nvchad' nvim"

alias wifi-on="nmcli radio wifi on"
alias wifi-off="nmcli radio wifi off"
alias wifi-list="wifi-on && nmcli device wifi list"
alias wifi-connect="nmcli device wifi connect --ask"
alias wifi-show="nmcli connection show"
alias wifi-up="nmcli connection up"
alias wifi-down="nmcli connection down"

alias audio-hdmi="pactl set-card-profile 0 output:hdmi-stereo-extra1"
alias audio-micro="pactl set-card-profile 0 output:analog-stereo+input:analog-stereo"

# SSH
alias s="ssh-menu"

alias t="tunnel-menu"
alias sshl="ssh -oKexAlgorithms=+diffie-hellman-group1-sha1"

# JUST
alias j="just"
alias just="just --unstable"

# ARCHLINUX
alias arch="archlinux"

# AWS
alias a="aws-ssm-connect"
alias as="aws-ssm-connect ssh"
alias am="aws-profile-menu"

# GIT
alias g="git"
alias gm="git-menu"
alias wk="workspace"
alias ck="workspace move"
alias git-id-personal="git config user.name 'Miguel López Ruiz' && git config user.email 'miguel.lr96@gmail.com'"
alias git-id-logalty="git config user.name 'Miguel López Ruiz' && git config user.email 'miguel.lopez@logalty.com'"

# KUBERNETES
alias k="kubectl --context"
alias ka="kustomize-menu apply"
alias ke="kubectl-menu edit pod"
# alias kc="kubectl-menu get -o yaml pod"
alias kdf="kustomize-menu diff"
alias kb="kustomize-menu bundle"
alias ks="kubectl-shell-menu"
alias kl="kubectl-log-menu"
alias kp="kubectl-menu port-forward pods"
alias kt="kubectl-run-pod"
alias kdrain="kubectl drain --delete-emptydir-data --ignore-daemonsets --disable-eviction --force --context"
alias k9="k9s -c pods --context"

# HELM
alias helm-list="helm ls -A --kube-context"

# PYTHON
alias d="deactivate"

# ZELLIJ
alias zel="zellij -s $USER"

# SETTINGS
alias se="settings"

# DISTROBOX
alias ds="distrobox-menu"
alias system="distrobox-host-exec bash"
alias system-root="distrobox-host-exec sudo bash"

# FUNCTIONS
autoload -Uz ${ZDOTDIR}/functions/*(.:t)

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

ssh() {
  TERM=xterm-256color command ssh "$@"
}

fkill () {
  local pid=$(ps -ef | sed 1d | fzf | awk '{print $2}')
  [ "x$pid" != "x" ] && kill -${1:-9} $pid
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

echo > /dev/null
