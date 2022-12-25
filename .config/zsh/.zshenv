#!/usr/bin/zsh

## PATH
paths="/usr/local/bin $HOME/.local/bin"
for npath in $(echo $paths | tr ' ' '\n'); do
  ! echo :$PATH: | grep -o "$npath" &>/dev/null && export PATH=$PATH:$npath
done

## XDG
# export XDG_DATA_HOME=$HOME/.local/share
# export XDG_CONFIG_HOME=$HOME/.config
export XDG_STATE_HOME=$HOME/.local/share/state

## ENV
export SHELL=/usr/bin/zsh
export HOSTNAME=$(hostname)
export EDITOR=nvim
export GNUPGHOME="$HOME/.config/gnupg"
#export TERM=xterm-256color

## LANG
lang=$(cat /etc/locale.conf &> /dev/null | grep -i "^LANG=" | cut -d"=" -f 2)
if [ -n "$lang" ]; then
  export LC_ALL=$lang
  export LANG=$lang
fi
unset lang

## KUBECTL
export KUBECONFIG="$HOME/.config/kube/config"

## NVIM
#export NVIM_PYTHON_LOG_FILE="/tmp/$USER/nvim.log"

## ODBC
export ODBCINI=$HOME/.config/odbc.ini
export ODBCINSTINI=..$HOME/.config/odbcinst.ini

## PYTHON

## NODEJS
export npm_config_prefix="$HOME/.local"

## ANSIBLE
export ANSIBLE_CONFIG=$HOME/.config/ansible.cfg
#export ROLES_PATH="$HOME/Projects/GrupoTRC/ansible/roles"
#export ANSIBLE_ROLES_PATH=~/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles:./roles:./ansible/roles
#export ANSIBLE_ROLES_PATH=$ANSIBLE_ROLES_PATH:$HOME/Projects/GrupoTRC/ansible/roles

# PASS
export GNUPGHOME="$HOME/.config/gnupg"
export PASSWORD_STORE_DIR="$HOME/.local/share/vault"
export PASSWORD_STORE_CLIP_TIME=8

## DEV
# export ANDROID_HOME=$HOME/.local/android/sdk
# export ANDROID_SDK_ROOT=$HOME/.local/android/sdk

# FZF
#export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_DEFAULT_OPTS="--layout=reverse --inline-info"

# AWS CLI (in profile)
#export AWS_DEFAULT_REGION="eu-west-1"
#export AWS_ACCESS_KEY_ID="AKIA2XRGJ4P2X52I47GB"
#[ -e $HOME/.local/share/vault/aws_secret_access_key ] && \
#  export AWS_SECRET_ACCESS_KEY="$(cat $HOME/.local/share/vault/aws_secret_access_key)"

# 
