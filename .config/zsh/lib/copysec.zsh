#!/usr/bin/zsh

function _copysec_usage() {
    local msg=$1

    echo "$msg"
    echo "copysec rsync root@192.168.1.230:/mnt/backup"
}

function _backup() {
    copysec rsync root@192.168.1.230:/mnt/backups/lg
}

function copysec() {
    local commands=("rsync" "borg")
    local command=$1
    local dst=$(echo $2 | sed 's#/*$##g')
    local options
    local exclude_file include_file
    shift

    [[ ! "${commands[@]}" =~ "$command" ]] && _copysec_usage "Command $command not valid." && return 1
    [ -z "$dst" ] && _copysec_usage "Enter a valid dst" && return 1

    if [ "$command" = "rsync" ]; then
        include_file="$HOME/.config/copysec/rsync-include.conf"
        exclude_file="$HOME/.config/copysec/rsync-exclude.conf"

        options="-rav -c --delete-after --delete-excluded"
        options+=" --exclude-from=$exclude_file --include-from=$include_file --exclude='*'"

        eval "sudo rsync $options / $dst/"
    fi
}
