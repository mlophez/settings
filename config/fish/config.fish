# ============================================================
# ENVIRONMENT — runs for all shells (interactive and scripts)
# ============================================================

# PATH
fish_add_path --path $HOME/.config/scripts
fish_add_path --path $HOME/.local/bin
fish_add_path --path /usr/local/bin

# SHELL
set -gx HOSTNAME (hostname)
set -gx EDITOR nvim

# XDG
set -gx XDG_STATE_HOME $HOME/.local/share/state

# GNUPG / PASS
set -gx GNUPGHOME $HOME/.config/gnupg
set -gx PASSWORD_STORE_DIR $HOME/.local/share/vault
set -gx PASSWORD_STORE_CLIP_TIME 8

# FZF
set -gx FZF_DEFAULT_OPTS '-m --ansi --layout=reverse --inline-info --prompt=➤\  --pointer=➤ --marker=➤ --color fg:-1,bg:-1,hl:#fab387 --color fg+:#b4befe,bg+:-1,hl+:#fab387 --color prompt:166'

# AWS
set -gx AWS_PROFILE none

# KUBERNETES
set -gx KUBECONFIG $HOME/.config/kube/config
set -gx KUBE_EDITOR nvim
set -gx HELM_CONFIG_HOME $HOME/.config/helm

# ANSIBLE
set -gx ANSIBLE_CONFIG $HOME/.config/ansible.cfg

# TERRAFORM
set -gx TF_PLUGIN_CACHE_DIR $HOME/.local/share/terraform/plugin-cache
mkdir -p $TF_PLUGIN_CACHE_DIR 2>/dev/null

# PYTHON
set -gx PYLINTRC $HOME/.config/pylintrc

# GO
set -gx GOPATH $HOME/.local/share/go
set -gx GOMAXPROCS 4
fish_add_path --path $GOPATH/bin

# RUST
set -gx RUSTUP_HOME $HOME/.local/share/rustup

# NODEJS
set -gx NPM_CONFIG_PREFIX $HOME/.local

# JAVA
set -gx M2_HOME $HOME/.local/share/maven

# FLUTTER
set -gx FLUTTER_HOME $HOME/.local/share/flutter/default
fish_add_path --path $FLUTTER_HOME/bin
fish_add_path --path $HOME/.pub-cache/bin

# RUBY
set -gx GEM_HOME $HOME/.local/share/ruby

# PODMAN
set -gx DOCKER_HOST "unix:///run/user/$UID/podman/podman.sock"

# BREW (macOS)
if test (uname) = Darwin
    fish_add_path --path /opt/homebrew/bin /opt/podman/bin
end

# NIX
fish_add_path --path $HOME/.nix-profile/bin

# OPENCODE
fish_add_path --path $HOME/.opencode/bin

# NETSKOPE
set -l netskope_cert $HOME/.local/share/certificates/netskope.crt
if test -e $netskope_cert
    set -gx AWS_CA_BUNDLE $netskope_cert
    set -gx REQUESTS_CA_BUNDLE $netskope_cert
    set -gx CURL_CA_BUNDLE $netskope_cert
    set -gx NODE_EXTRA_CA_CERTS $netskope_cert
    set -gx GIT_SSL_CAINFO $netskope_cert
    set -gx SSL_CERT_FILE $netskope_cert
    set -gx JAVA_TOOL_OPTIONS "-Djavax.net.ssl.trustStore=$HOME/.local/share/certificates/netskope.jks -Djavax.net.ssl.trustStorePassword=changeit"
end

# LOCAL ENVIRONMENT (secretos/overrides no versionados)
if test -e $HOME/.local/share/environment.fish
    source $HOME/.local/share/environment.fish
end

# NIX (fish-native)
if test -e $HOME/.nix-profile/etc/profile.d/nix.fish
    source $HOME/.nix-profile/etc/profile.d/nix.fish
else if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
    source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
end

# NIX LOCALE (Linux)
if test -f /usr/lib/locale/locale-archive
    set -gx LOCALE_ARCHIVE /usr/lib/locale/locale-archive
end

# HOME MANAGER (fish-native, si existe)
if test -e $HOME/.nix-profile/etc/profile.d/hm-session-vars.fish
    source $HOME/.nix-profile/etc/profile.d/hm-session-vars.fish
end

# HYPRLAND autostart (Linux, login shell, TTY1, no Wayland)
if status is-login
    and test -z "$WAYLAND_DISPLAY"
    and test (tty) = /dev/tty1
    and type -q Hyprland
    exec systemd-run --user --scope --unit=hyprland.scope --slice=desktop.slice -- nixGL Hyprland
end

# ============================================================
# INTERACTIVE ONLY
# ============================================================

if not status is-interactive
    return
end

set -g fish_greeting

umask 022

# Cursor shape: blinking bar antes de cada prompt
function __set_cursor --on-event fish_prompt
    printf '\e[5 q'
end

# Fix nixGL
set -e LD_LIBRARY_PATH
set -e LIBGL_DRIVERS_PATH
set -e LIBVA_DRIVERS_PATH
set -e __EGL_VENDOR_LIBRARY_FILENAMES

# Starship prompt
if type -q starship
    starship init fish | source
end

# Kubectl completions
if type -q kubectl
    kubectl completion fish | source
end

# ============================================================
# ALIASES
# ============================================================

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
alias ck 'workspace move'
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

# TERRAFORM
alias ti 'terraform init'
alias tv 'terraform validate'
alias tp 'terraform plan'
alias ta 'terraform apply'
alias tmv 'terraform state mv'
alias terraspace 'docker run -ti -v (pwd):/workspace -w /workspace ghcr.io/boltops-tools/terraspace:alpine'

# PYTHON
alias d deactivate

# ZELLIJ
alias zel 'zellij attach 0; or exec zellij -s 0'

# SETTINGS
alias se settings

# DISTROBOX
alias ds distrobox-menu
alias user 'distrobox-host-exec bash'
alias admin 'distrobox-host-exec sudo bash'
alias root 'distrobox-host-exec sudo bash'

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
alias ai claude
alias aib claude-with-bedrock
alias bai claude-with-bedrock
alias oc opencode
alias ail "claude --add-dir $HOME/Code/assistant-ai"
