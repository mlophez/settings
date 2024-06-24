#!/usr/bin/zsh

# ZSH
export ZDOTDIR=$HOME/.config/zsh
export KEYTIMEOUT=1

export PATH=${PATH}:${HOME}/.config/scripts
export FPATH=${FPATH}:${ZDOTDIR}/functions

# SHELL
export SHELL=/usr/bin/zsh
export HOSTNAME=$(hostname)
export EDITOR=nvim
export TERM=xterm-256color

# XDG
export XDG_STATE_HOME=$HOME/.local/share/state

# SPACESHIP
export SPACESHIP_CONFIG="$HOME/.config/zsh/spaceship.zsh"

# PASS
export GNUPGHOME="$HOME/.config/gnupg"
export PASSWORD_STORE_DIR="$HOME/.local/share/vault"
export PASSWORD_STORE_CLIP_TIME=8

# FZF
FZF_DEFAULT_OPTS=""
FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS} -m --ansi --layout=reverse --inline-info"
FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS} --prompt='➤ ' --pointer='➤' --marker='➤'"
FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS} --color 'fg:-1,bg:-1,hl:#fab387'"
FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS} --color 'fg+:#b4befe,bg+:-1,hl+:#fab387'"
FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS} --color 'prompt:166'"
export FZF_DEFAULT_OPTS

# AWS
export AWS_PROFILE="none"

# KUBERNETES
export KUBECONFIG="$HOME/.config/kube/config"
export KUBE_EDITOR="nvim"
export HELM_CONFIG_HOME="$HOME/.config/helm"

# ANSIBLE
export ANSIBLE_CONFIG=$HOME/.config/ansible.cfg

# PYTHON
export PYLINTRC="$HOME/.config/pylintrc"

# GO
export GOPATH="$HOME/.local/share/go"
export PATH=${PATH}:${GOPATH}/bin

# RUST
export RUSTUP_HOME="$HOME/.local/share/rustup"

# NODEJS
export NPM_CONFIG_PREFIX="$HOME/.local"

# JAVA
export M2_HOME="$HOME/.local/share/maven"

# ANDROID
export ANDROID_HOME=${HOME}/.local/share/android
export PATH=${PATH}:${ANDROID_HOME}/platform-tools
export PATH=${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin

# FLUTTER
export FLUTTER_HOME=${HOME}/.local/share/flutter/default
export PATH=${PATH}:${FLUTTER_HOME}/bin

# RUBY
export GEM_HOME=$HOME/.local/share/ruby

# PATH
export PATH=${PATH}:/usr/local/bin
export PATH=${PATH}:${HOME}/.local/bin

# PODMAN
export DOCKER_HOST="unix:///run/user/$UID/podman/podman.sock"

if [ -n "$CONTAINER_ID" ]; then
  export DBUS_SYSTEM_BUS_ADDRESS=unix:path=/run/host/run/dbus/system_bus_socket
else
  unset DBUS_SYSTEM_BUS_ADDRESS
fi

# export LOCALE_ARCHIVE="$(nix-env --installed --no-name --out-path --query glibc-locales)/lib/locale/locale-archive"
