#!/usr/bin/zsh

alias reload="exec zsh"
alias ll="ls -lh"
alias mkdir="command mkdir -vp"

alias v="nvim"
alias vi="nvim"
alias vim="nvim"
alias cc="cd \$(find . -type d -print | fzf)"
alias edit="nvim \$(find . -type f -print | fzf)"
alias e="editor"

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
alias ks="kubectl-shell-menu"
alias kl="kubectl-log-menu"
alias kp="kubectl-menu port-forward pods"
alias kt="kubectl-run-pod"
alias kdrain="kubectl drain --delete-emptydir-data --ignore-daemonsets --disable-eviction --force --context"
alias k9="k9s -c pods --context"

# PYTHON
alias d="deactivate"

# ZELLIJ
alias zel="zellij -s $USER"

# SETTINGS
alias se="settings"
