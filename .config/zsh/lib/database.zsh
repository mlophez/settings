#!/usr/bin/zsh

function db () {
    local profile=$1
    local width=$2
    local user password

    [ -z "$width" ] && width="25"
    [ -z "$(cat $HOME/.config/odbc.ini | grep "\[$profile]")" ] && echo "[-] Profile do not exists in odbc" && return 1

    local key=$(echo $profile | tr '[:upper:]' '[:lower:]')
    user=$(pass db/$key user 2>/dev/null)
    [ $? -ne 0 ] && pass insert -m db/$key
    password=$(pass db/$key password 2>/dev/null)
    [ $? -ne 0 ] && pass edit db/$key

    eval "isql -v -n -L$width '$profile' '$user' '$password'"
}

function dbexec () {
    local profile=$1
    local query=$2
    local user password

    [ -z "$(cat $HOME/.config/odbc.ini | grep "\[$profile]")" ] && echo "[-] Profile do not exists in odbc" && return 1

    local key=$(echo $profile | tr '[:upper:]' '[:lower:]')
    user=$(pass db/$key user 2>/dev/null)
    [ $? -ne 0 ] && pass insert -m db/$key
    password=$(pass db/$key password 2>/dev/null)
    [ $? -ne 0 ] && pass edit db/$key

    eval "echo \"$query\" | isql -v -b -L100 '$profile' '$user' '$password'"
}
