#!/usr/bin/zsh

function rofi-menu() {
    local config=$1
    [ ! -e "$config" ] && return 1
    rofi -show drun -i -config $config
}

function rofi-start() {
    local config=$1
    local opt
    [ ! -e "$config" ] && return 1
    opt=$(printf "WORK\nNORMAL" | rofi -dmenu -i -p "Start" -config $config)
    if [ $opt = "WORK" ]; then
    fi
}

function rofi-pass() {
    local config=$1
    local entry entries
    local subvalue subvalues

    [ ! -e "$config" ] && return 1

    entries=$(find $PASSWORD_STORE_DIR -type f -name \*.gpg | sed "s#$PASSWORD_STORE_DIR/*##g" | sed 's/\.gpg$//g')
    entry=$(printf "$entries" | rofi -dmenu -i -p "Entry" -config $config)

    subvalues=$(pass $entry | grep -n "^[a-zA-Z0-9]*:.*$" | cut -d ":" -f 1,2)
    if [ -n "$subvalues" ]; then
        subvalue=$(printf "1:password\n$subvalues" | rofi -dmenu -i -p "SubEntry" -config $config)
        pass -c $entry $(echo $subvalue | cut -d":" -f 2)
    else
        pass show -c $entry
    fi
}

function rofi-connect() {
    local config=$1
    local notification_name="NETWORK"
    local connections connection wifi
    #IFS=$'\n'

    [ ! -e "$config" ] && return 1

    connections=$(nmcli --fields "NAME" connection show | sed 's/ *$//g' | grep -v NAME | sort | uniq)
    wifi=$(nmcli radio wifi)
    
    #rofi -show window -config ~/.config/rofi/config.rasi
    #rofi -dmenu -p "Connection" -config ~/.config/rofi/config.rasi
    
    #for connection in $connection_LIST; do
    #    eval "nmcli connection modify '$connection' connection.autoconnect no"
    #    eval "nmcli connection modify '$connection' ipv6.method disabled"
    #done
    
    connection=$(printf "$connections" | rofi -dmenu -i -p "Connection" -config $config)
    [ "$connection" = "" ] && return 0
    
    type=$(nmcli connection show "$connection" | grep connection.type: | sed 's/[ \t]//g' | cut -d":" -f2-100)
    
    if [[ $type =~ "wireless|wifi" ]] && [ "$wifi" != "enabled" ]; then
        nmcli radio wifi on
        sleep 3
    fi
    
    eval "nmcli connection modify '$connection' connection.autoconnect no"
    eval "nmcli connection modify '$connection' ipv6.method disabled"
    
    output=$(nmcli connection up $connection)
    if [ $? -eq 0 ]; then
        notify-send -u low "$notification_name" "Conexión '$connection' activada con éxito."
    else
        notify-send -u critical "$notification_name" "$output"
    fi

    return 0
}
