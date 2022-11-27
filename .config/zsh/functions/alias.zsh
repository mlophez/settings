#!/usr/bin/zsh

#### ALIAS
alias reload="exec zsh"
alias config="nvim ~/Projects/archlinux/files/zsh/zshrc"
alias ll="ls -lh"
alias mkdir="command mkdir -vp"
# alias rm="rm -rfi"
alias vi="editor"
alias vim="editor"
alias nvim="editor"

## MENU
alias menu="fzf-menu"
alias menu-pass="shell fzf-pass"
alias menu-connect="fzf-connect"
alias menu-contact="fzf-contact"
alias menu-logout="fzf-logout"

## TMUX
alias tmux="command tmux -f $HOME/.config/tmux/tmux.conf"

## DOCKER
alias dc="docker-compose"

## GIT
alias g="git"
alias save="git add . && git commit -m \"$(date '+%Y-%m-%d %H:%M:%S')\""
alias undo="git reset --soft HEAD~1"

## TASK
alias configure="$HOME/.local/bin/configure"

## ANSIBLE
alias playbook="ansible-playbook"
alias role-ubuntu="ansible-playbook -k ~/Projects/GrupoTRC/ansible/playbooks/ubuntu.yaml"
alias role-docker="ansible-playbook -k ~/Projects/GrupoTRC/ansible/playbooks/docker.yaml"

## WIFI
alias wifi-on="nmcli radio wifi on"
alias wifi-off="nmcli radio wifi off"
alias wifi-list="wifi-on && nmcli device wifi list"
alias wifi-connect="nmcli device wifi connect --ask"
alias wifi-show="nmcli connection show"
alias wifi-up="nmcli connection up"
alias wifi-down="nmcli connection down"

## NOTIFY
alias info="notify-send -u low -t 3000"
alias warn="notify-send -u normal -t 3000"
alias critical="notify-send -u critical -t 3000"

## SERVER
alias server-up="wol 00:4e:01:c5:bb:49"
alias server-ssh="sshn root@192.168.1.230"
alias server-tunnel="ssh -N -D5555 root@192.168.1.230"

## AUDIO
alias audio-hdmi="pactl set-card-profile 0 output:hdmi-stereo-extra1"
alias audio-micro="pactl set-card-profile 0 output:analog-stereo+input:analog-stereo"

## GCALCLI
alias gcalcli="command gcalcli --config-folder $HOME/.config/gcalcli"
