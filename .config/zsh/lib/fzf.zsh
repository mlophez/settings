#!/usr/bin/zsh

_fzf_cfgfile="$HOME/.config/fzfdicts"

function shell() {
    local fontsize="18"
    local opts="-o window.padding.x=51 -o window.padding.y=20 -o font.size=$fontsize -o windows.opacity=1"
    
    # ALACRITTY THEME
    # opts="$opts --config-file $HOME/.config/alacritty/nord.yml"

    eval "alacritty --class 'menu' $opts -e /usr/bin/zsh -i -c '$@' &>/dev/null"
}

function fzfmenu() {
    local fontsize="18"
    local opts="-o window.padding.x=51 -o window.padding.y=20 -o font.size=$fontsize -o windows.opacity=1"
    local fzf_opts="--layout=reverse --inline-info --color border:13 -i"

    # ALACRITTY THEME
    # opts="$opts --config-file $HOME/.config/alacritty/nord.yml"

    unset FZF_DEFAULT_COMMAND
    unset FZF_DEFAULT_OPTS

    cat << EOF > $HOME/.local/bin/fzfmenu
#!/bin/bash
alacritty --class 'menu' $opts -e /bin/bash -c "/usr/bin/fzf $fzf_opts \$* < /proc/\$\$/fd/0 > /proc/\$\$/fd/1"
EOF
    chmod 755 $HOME/.local/bin/fzfmenu

    command fzfmenu
}

function fzfdicts() {
    local file
    local locations=(/usr/share/applications $HOME/.local/share/applications $HOME/Desktop)

    #cat /dev/null > $_fzf_cfgfile
    cat << EOF > /tmp/awk
BEGIN {IGNORECASE = 1}
/\[Desktop Entry/{ f=1; next }
/\[/{ f=0; next }
f && {print \$0}
f && \$1==Name{ print \$0 }
f && \$1==Exec{ print \$0 }
EOF

    for location in $locations; do
        echo "[+] Searching in $location"
        for file in $(find $location -name '*.desktop' -type f); do
            awk -F'=' -f /tmp/awk $file

            #local name=$(cat "$file" | grep -i "^name=" | head -1 | cut -d "=" -f 2-1000)
           
            #local terminal=$(cat $file | grep -i "^terminal=" | head -1 | cut -d "=" -f 2-1000)
            #[ "$terminal" = "true" ] && continue

            #[ -z "$(cat $_fzf_cfgfile | grep "$name|")" ] && echo "$name|$file" >> $_fzf_cfgfile
        done
    done
}

function fzf-menu() {
    local locations=(/usr/share/applications $HOME/.local/share/applications $HOME/Desktop)
    local opt cmd

    # GET DATA
    cat $HOME/.config/fzfapps | grep -v "^ *#" | sort -u | xargs -i echo "$GLYPH_DESKTOP {}" > /tmp/$USER/fzfapps

    #for location in $locations; do
    #    for file in $(find $location -name \*.desktop -type f); do
    #        [ -z "$(cat $file | grep -i '^ *\[Desktop * Entry\] *$')" ] && continue
    #        echo "$GLYPH_COMMAND $(basename $file)" >> /tmp/$USER/fzfapps
    #    done
    #done
    #    #find $path -maxdepth 1 -type f,l | xargs -n1 basename | xargs -i echo "$GLYPH_COMMAND {}:{}" >> /tmp/$USER/fzfapps
    #    find $pa -maxdepth 1 -type f,l | xargs -n1 basename | xargs -i echo "$GLYPH_COMMAND {}:{}"
    #done

    opt=$(cat /tmp/$USER/fzfapps | grep -v -e "^ *#" -e "^ *$"  | cut -d":" -f1 | fzfmenu)
    [ -z "$opt" ] && return 1

    cmd=$(cat /tmp/$USER/fzfapps | grep "^$opt:" | cut -d":" -f2-1000000000)
    echo $cmd
    eval $cmd
}

function fzf-menu2() {
    local opt cmd

    cat $HOME/.config/fzfapps > /tmp/$USER/fzfapps
    find $HOME/.local/bin -maxdepth 1 -type f,l | xargs -n1 basename | xargs -i echo {}:{} >> /tmp/$USER/fzfapps

    opt=$(cat /tmp/$USER/fzfapps | grep -v -e "^ *#" -e "^ *$"  | cut -d":" -f1 | fzf)
    [ -z "$opt" ] && return 1

    cmd=$(cat /tmp/$USER/fzfapps | grep "^$opt:" | cut -d":" -f2-1000000000)
    echo $cmd
    eval $cmd
}

function fzf-binary() {
    binary=$(find $(echo $PATH | tr ':' ' ') -maxdepth 1 -type f,l | xargs -n1 basename | fzfmenu)
    eval $binary
}

function fzf-pass() {
    local entry entries
    local subvalue subvalues

    entries=$(pass list)
    entry=$(printf "$entries" | fzf)

    subvalues=$(pass $entry | grep -n "^[a-zA-Z0-9]*:.*$" | cut -d ":" -f 1,2)
    if [ -n "$subvalues" ]; then
        subvalue=$(printf "1:password\n$subvalues" | fzf)
        pass -c $entry $(echo $subvalue | cut -d":" -f 2)
    else
        pass show -c $entry
    fi
}

function fzf-contact() {
    local entries=$(abook --mutt-query '' --outformat vcard | grep EMAIL | cut -d":" -f2 | uniq)
    local entry=$(printf "$entries" | fzfmenu)
    [ -z "$entry" ] && return 1
    echo $entry | clipboard
}

function connect() {
    local notification_name="NETWORK"
    local connections connection wifi interface
    #IFS=$'\n'

    connections=$(nmcli --fields "NAME" connection show | grep -v "docker0" | sed 's/ *$//g' | grep -v NAME | sort | uniq)
    wifi=$(nmcli radio wifi)
    
    #rofi -show window -config ~/.config/rofi/config.rasi
    #rofi -dmenu -p "Connection" -config ~/.config/rofi/config.rasi
    
    #for connection in $connection_LIST; do
    #    eval "nmcli connection modify '$connection' connection.autoconnect no"
    #    eval "nmcli connection modify '$connection' ipv6.method disabled"
    #done
    
    connection=$(printf "$connections" | fzf)
    [ "$connection" = "" ] && return 0

    # WIFI CONNECT
    type=$(nmcli connection show "$connection" | grep connection.type: | sed 's/[ \t]//g' | cut -d":" -f2-100)
    
    if [[ $type =~ "wireless|wifi" ]]; then
        if [ "$wifi" != "enabled" ]; then
            nmcli radio wifi on
            sleep 3
        fi
        interface=$(find /sys/class/net/ -follow -maxdepth 2 -name wireless 2> /dev/null | head -1 | cut -d / -f 5)
        eval "nmcli connection modify '$connection' connection.interface-name $interface"
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

function fzf-logout() {
    local opt=$(printf "POWEROFF\nREBOOT\nLOGOUT" | fzfmenu)
    [ -n "$opt" ] && onexit
    if [ "$opt" = "POWEROFF" ]; then
        systemctl poweroff
    elif [ "$opt" = "REBOOT" ]; then
        systemctl reboot
    elif [ "$opt" = "LOGOUT" ]; then
        deskexit
    fi
}

# ACCESS DIRECT
## BLUETHOOTH

alias b="bluetooth"
function bluetooth() {
    [ "$(systemctl is-active bluetooth.service)" = "inactive" ] && sudo systemctl start bluetooth.service

    device=$(bluetoothctl devices | fzf)
    [ -z "$device" ] && return -1

    bluetoothctl power on
    bluetoothctl connect "$(echo $device | cut -d' ' -f 2)"
}
 
## PASS
function p() {
    local entries=$(pass list)
    local entry=$(printf "$entries" | fzf)
    [ -z "$entry" ] && return 

    eval "pass $entry"
}

function pe() {
    local entries=$(pass list)
    local entry=$(printf "$entries" | fzf)
    [ -z "$entry" ] && return 

    eval "pass edit $entry"
}

## REPEAT
alias r="fzf-repeat"
alias re="fzf-repeat"
function fzf-repeat() {
    local entry=$(cat $HOME/.config/fzfrepeat | fzf)
    eval "$entry"
}

## JAVA
alias j="javafzf"
function javafzf() {
    local entry=$(archlinux-java status | grep "^ " | sed 's/^ *//g' |cut -d" " -f1 | fzf)
    [ -z "$entry" ] && return 
    sudo archlinux-java set $entry
}

## db
function d() {
    local entries=$(pass list | grep "^db")
    local entry=$(printf "$entries" | tr '[:lower:]' '[:upper:]' | fzf)
    [ -z "$entry" ] && return 

    local cmd=$(pass db/$(basename $entry | tr '[:upper:]' '[:lower:]') sqlline 2>/dev/null)
    eval "sqlline $cmd"
}

### WORKSPACE
bindkey -s '^p' '_w\n'
alias _w="workspace"
function workspace() {
  local wpath=($(find $HOME -maxdepth 2 -iname Projects -type d -print | tr '\n' ' '))
  cd $(find $wpath -mindepth 1 -maxdepth 1 -type d -print | fzf)
}
