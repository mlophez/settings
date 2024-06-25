#!/usr/bin/zsh

alias reload="exec zsh"
alias ll="ls -lh"
alias mkdir="command mkdir -vp"

alias v="nvim"
alias vi="nvim"
alias vim="nvim"
alias cc="cd \$(find . -type d -print | fzf)"
alias edit="nvim \$(find . -type f -print | fzf)"

alias f="function-menu"

# DOT
alias config="cd $HOME/.config && nvim"
alias status="dot changes"
alias save="dot save"
alias load="dot load"

alias nvchad="NVIM_APPNAME='nvchad' nvim"
alias astrovim="NVIM_APPNAME='astrovim' nvim"

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
alias sshl="ssh -oKexAlgorithms=+diffie-hellman-group1-sha1"

# JUST
alias j="just"

# ARCHLINUX
alias arch="archlinux"

# AWS
alias a="aws --profile"
alias ac="aws-ssm-connect"
alias as="aws-ssm-connect ssh"
alias am="aws-profile-menu"

# GIT
alias g="git"
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gd="git diff"
alias gm="git-menu"
alias gcb="git-create-random-branch"
alias gi="git-identity"
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
alias kb="kustomize build --enable-helm --load-restrictor LoadRestrictionsNone"
alias ks="kubectl-shell-menu"
alias kl="kubectl-log-menu"
alias kp="kubectl-menu port-forward pods"
alias kt="kubectl-run-pod"
alias kdrain="kubectl drain --delete-emptydir-data --ignore-daemonsets --disable-eviction --force --context"
alias k9="k9s -c pods --all-namespaces --context"

# HELM
alias helm-list="helm ls -A --kube-context"

# KUBESEAL
alias kubeseal="command kubeseal --controller-namespace kube-system --controller-name sealed-secrets --scope cluster-wide"

# TERRAFORM
alias ti="terraform init"
alias tv="terraform validate"
alias tp="terraform plan"
alias ta="terraform apply"
alias tmv="terraform state mv"

# PYTHON
alias d="deactivate"

# ZELLIJ
alias zel="zellij -s $USER"

# SETTINGS
alias se="settings"

# DISTROBOX
alias ds="distrobox-menu"
alias sys="distrobox-host-exec bash"
alias sysadmin="distrobox-host-exec sudo bash"
alias root="distrobox-host-exec sudo bash"

# SYSTEMD
alias systemctl="systemctl --user"

# HOME-MANAGER
alias switch="home-manager switch --impure"
