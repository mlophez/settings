status is-interactive; or return

alias reload 'exec fish'
alias ll 'ls -lh'
alias mkdir 'command mkdir -vp'

alias v nvim
alias vi nvim
alias vim nvim

alias f function-menu

alias config "cd $HOME/.config && nvim"
alias dot-status 'dot changes'
alias dot-save 'dot save'
alias dot-load 'dot load'

alias nvchad "NVIM_APPNAME='nvchad' nvim"
alias astrovim "NVIM_APPNAME='astrovim' nvim"

alias wifi-on 'nmcli radio wifi on'
alias wifi-off 'nmcli radio wifi off'
alias wifi-list 'wifi-on && nmcli device wifi list'
alias wifi-connect 'nmcli device wifi connect --ask'
alias wifi-show 'nmcli connection show'
alias wifi-up 'nmcli connection up'
alias wifi-down 'nmcli connection down'

alias audio-hdmi 'pactl set-card-profile 0 output:hdmi-stereo-extra1'
alias audio-micro 'pactl set-card-profile 0 output:analog-stereo+input:analog-stereo'
alias clipboard pbcopy

# SSH
alias s ssh-menu
alias sshl 'ssh -oKexAlgorithms=+diffie-hellman-group1-sha1'

# JUST
alias j just

# ARCHLINUX
alias arch 'uname -m'

# AWS
alias a 'aws --profile'
alias ac aws-ssm-connect
alias as 'aws-ssm-connect ssh'
alias am aws-profile-menu

# GIT
alias g git
alias gs 'git status'
alias ga 'git add'
alias gc 'git commit'
alias gd 'git diff'
alias gm git-menu
alias gcb git-create-random-branch
alias gi git-identity
alias wk workspace
alias gp goproject
alias git-id-personal "git config user.name 'Miguel López Ruiz' && git config user.email 'miguel.lr96@gmail.com'"
alias git-id-logalty "git config user.name 'Miguel López Ruiz' && git config user.email 'miguel.lopez@logalty.com'"

# KUBERNETES
alias k 'kubectl --context'
alias ka 'kustomize-menu apply'
alias ke 'kubectl-menu edit pod'
alias kdf 'kustomize-menu diff'
alias kb 'kustomize build --enable-helm --load-restrictor LoadRestrictionsNone'
alias ks kubectl-shell-menu
alias kl kubectl-log-menu
alias kp 'kubectl-menu port-forward pods'
alias kt kubectl-run-pod
alias kdrain 'kubectl drain --delete-emptydir-data --ignore-daemonsets --disable-eviction --force --context'
alias k9 'k9s -c pods --all-namespaces --context'
alias k9conf "find $HOME/.local/share/k9s -name config.yaml | xargs -I@ sed 's/nodeShell: false/nodeShell: true/g' -i @"

# HELM
alias helm-list 'helm ls -A --kube-context'

# KUBESEAL
alias kubeseal 'command kubeseal --controller-namespace kube-system --controller-name sealed-secrets --scope cluster-wide'

# PYTHON
alias d deactivate

# WORKSPACE
alias ws workspace

# SETTINGS
alias se settings

# DISTROBOX
alias dx 'distrobox'

alias user 'distrobox-host-exec bash'
alias admin 'distrobox-host-exec sudo bash'
alias root 'distrobox-host-exec sudo bash'

alias archlinux 'exec distrobox enter archlinux -- fish'
alias fedora 'exec distrobox enter fedora -- fish'

# SYSTEMD
alias systemctl 'systemctl --user'

# HOME-MANAGER
alias hm-switch 'home-manager switch --impure'

# ANDROID
alias emu emulator

# YOUTUBE
alias youtube "mpv --ytdl-format='bestvideo[height<=?1080]+bestaudio/best'"
alias yt youtube
alias youtube-download-mp3 'yt-dlp -x --audio-format mp3'

# IA
alias ai "clear && claude"
alias aib claude-with-bedrock
alias bai claude-with-bedrock
alias oc opencode
alias ail "claude --add-dir $HOME/Code/Logalty --model sonnet --effort medium"
