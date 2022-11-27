#!/usr/bin/zsh

[[ -e $HOME/.local/share/zsh/zshenv ]] && source $HOME/.local/share/zsh/zshenv

## COMENTADO ADAPTAR A PLASMA
## # THEME
## ## CURSORS
## export XCURSOR_PATH=$HOME/.local/share/icons
## export XCURSOR_SIZE=32
## export XCURSOR_THEME="volantes-light-cursors"
## ## QT
## export QT_QPA_PLATFORMTHEME=qt5ct
## ## GTK
## export GTK_THEME=Nordic-Darker
## export GTK2_RC_FILES=$HOME/.local/share/themes/Nordic-Darker/gtk-2.0/gtkrc
## CUSTOM
## export THEME_ICON=candy-icons
## export THEME_FONT="Fira Code 14"

## # PATH
## export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
## export PATH=$PATH:$HOME/.local/bin
#export PATH=$PATH:$HOME/.local/flutter/bin
#export PATH=$PATH:$HOME/.local/android/android-studio/bin
#export PATH=$PATH:/var/lib/snapd/snap/bin
#export PATH=$PATH:/var/lib/flatpak/exports/bin

# XDG
#export XDG_DATA_DIRS=/usr/local/share:/usr/share
#export XDG_DATA_DIRS=$XDG_DATA_DIRS:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share
#export XDG_DATA_DIRS=$XDG_DATA_DIRS:/var/lib/snapd/desktop

## THEME
export ALACRITTY_THEME="${ALACRITTY_THEME:=nord}"

## ENV
export HOSTNAME=$(hostname)
#export TERM=xterm-256color
export EDITOR=nvim
export NVIM_PYTHON_LOG_FILE="/tmp/$USER/nvim.log"
export GNUPGHOME="$HOME/.config/gnupg"

## KUBECTL
export KUBECONFIG="$HOME/.config/kube/config"

## ODBC
export ODBCINI=$HOME/.config/odbc.ini
export ODBCINSTINI=..$HOME/.config/odbcinst.ini

## PYTHON
#export PYTHONCFG=$HOME/.local/python
#export PYTHONPATH=$PYTHONCFG/lib/python$(python --version | cut -d" " -f2 | cut -d"." -f1,2)/site-packages
#export PYTHONENVS=$PYTHONCFG/envs

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
