#!/usr/bin/zsh

function rdp() {
    local cmd=$1
    local options="/cert-ignore /bpp:16 /dynamic-resolution -grab-keyboard"
    options="$options /drive:RDPFolder,$HOME/Share/Remmina"

    if [ "$cmd" = "list" ]; then
        pass list | grep "^rdp/"
    elif [ "$cmd" = "connect" ]; then
        local search=$(pass list | grep ^rdp | grep "$2" | head -1)
        [ -z "$search" ] && echo "[-] Profile $2 do not exists." && return 1

        local user=$(pass $search user)
        local passwd=$(pass $search password)
        local server=$(pass $search server)
        eval "wlfreerdp $options /v:$server /u:$user /p:'$passwd'"
    else
        echo "[-] Error"
    fi
}

function rdpconn() {
    local server=$1
    local user=$2
    local passwd=$3
    local options="/cert-ignore /bpp:16 /dynamic-resolution -grab-keyboard"
    options="$options /drive:RDPFolder,$HOME/Share/Remmina"

    eval "wlfreerdp $options /v:$server /u:$user /p:'$passwd'"
}

# xfreerdp /cert-ignore /bpp:24 /dynamic-resolution -grab-keyboard /u:administrador /p:'j4l4B1n2011*' /v:192.168.100.146
