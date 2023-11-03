#!/usr/bin/zsh

# ZSH
export ZDOTDIR=$HOME/.config/zsh
export KEYTIMEOUT=1
export PATH=${PATH}:${ZDOTDIR}/scripts
export FPATH=${FPATH}:${ZDOTDIR}/functions

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
# export TF_PLUGIN_CACHE_DIR="$HOME/.local/share/terraform/plugins"

# KUBERNETES
export KUBECONFIG="$HOME/.config/kube/config"
export KUBE_EDITOR="nvim"
export HELM_CONFIG_HOME="$HOME/.config/helm"

# ANSIBLE
export ANSIBLE_CONFIG=$HOME/.config/ansible.cfg

# PYTHON
export PYTHONVENV="$HOME/.local/share/virtualenvs/local"
export PIPENV_IGNORE_VIRTUALENVS=1

# GO
export GOPATH="$HOME/.local/share/go"
export PATH=${PATH}:${GOPATH}/bin

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

# LANG
export LANG=$(cat /etc/locale.conf &> /dev/null | grep -i "^LANG=" | cut -d"=" -f 2)
export LC_ALL=$LANG

# ODBC
# export ODBCINI=$HOME/.config/odbc.ini
# export ODBCINSTINI=..$HOME/.config/odbcinst.ini


