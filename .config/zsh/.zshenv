#!/usr/bin/zsh

# ZSH
export ZDOTDIR=$HOME/.config/zsh
export PATH=${PATH}:${ZDOTDIR}/scripts
export FPATH=${FPATH}:${ZDOTDIR}/functions
export KEYTIMEOUT=1

# SHELL
export SHELL=/usr/bin/zsh
export HOSTNAME=$(hostname)
export EDITOR=nvim
# export TERM=xterm-256color

# XDG
export XDG_STATE_HOME=$HOME/.local/share/state

# SPACESHIP
export SPACESHIP_CONFIG="$HOME/.config/zsh/spaceship.zsh"

# PASS
export GNUPGHOME="$HOME/.config/gnupg"
export PASSWORD_STORE_DIR="$HOME/.local/share/vault"
export PASSWORD_STORE_CLIP_TIME=8

# FZF
# export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_DEFAULT_OPTS="--layout=reverse --inline-info"

# AWS
export AWS_PROFILE="none"

# TERRAFORM
export TF_PLUGIN_CACHE_DIR="$HOME/.local/share/terraform/plugins"

# KUBERNETES
export KUBECONFIG="$HOME/.config/kube/config"
export KUBE_EDITOR="nvim"
export HELM_CONFIG_HOME="$HOME/.config/helm"

# ANSIBLE
export ANSIBLE_CONFIG=$HOME/.config/ansible.cfg

# PYTHON
export PYTHONVENV="$HOME/.local/share/python"

# GO
export GOPATH="$HOME/.local/share/go"

# NODEJS
export NPM_CONFIG_PREFIX="$HOME/.local/share/nodejs"

# JAVA
export M2_HOME="$HOME/.local/share/maven"

# RUBY
export GEM_HOME=$HOME/.local/share/ruby

# PATH
export PATH=${PATH}:/usr/local/bin
export PATH=${PATH}:${HOME}/.local/bin
export PATH=${PATH}:${PYTHONVENV}/bin
export PATH=${PATH}:${GOPATH}/bin
export PATH=${PATH}:${NPM_CONFIG_PREFIX}/bin

# LANG
export LANG=$(cat /etc/locale.conf &> /dev/null | grep -i "^LANG=" | cut -d"=" -f 2)
export LC_ALL=$LANG

# ANDROID
# export ANDROID_HOME=$HOME/.local/share/android/sdk
# export ANDROID_SDK_ROOT=$HOME/.local/share/android/sdk

# ODBC
# export ODBCINI=$HOME/.config/odbc.ini
# export ODBCINSTINI=..$HOME/.config/odbcinst.ini


