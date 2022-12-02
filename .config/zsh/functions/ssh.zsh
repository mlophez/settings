#!/usr/bin/zsh

function docker-upload-image () {
    local host=$1
    local image=$2

    [ -z "$(docker images | sed 's/  */:/g' | grep $image)" ] && echo "[-] Image dont exists" && return 1
    #[[ "$image" =~ '^localhost' ]] && docker tag "$image" "$(echo $image | sed 's#localhost/##g')"

    docker save $image | pv | ssh -C $host docker load

    if [[ "$image" =~ '^localhost' ]]; then
        ssh $host "docker tag $image $(echo $image | sed 's#localhost/##g')"
        ssh $host "docker image rm $image"
    fi
}

function ssh () {
    cat /dev/null > /tmp/config

    [ -e $HOME/.ssh/config ] && cat $HOME/.ssh/config > /tmp/config

    #for x in $(ls $HOME/.ssh/ | grep conf); do
    #    cat ~/.ssh/$x >> /tmp/config
    #done

    printf "\e[?2004l"
    command ssh -F /tmp/config $@
}

function sshlegacy () {
    export TERM=xterm-256color

    printf "\e[?2004l"
    command ssh -oKexAlgorithms=+diffie-hellman-group1-sha1 $@
}

alias s="ssh-connect"
function ssh-connect() {
    local entries entry

    cat ~/.ssh/config > /tmp/config
    #cat ~/.ssh/*.conf >> /tmp/config

    entries=$(cat /tmp/config | grep -i "^Host" | grep -v "*" | sed 's/ \+/ /g' | cut -d" " -f2-100000 | sort)
    entry=$(printf "$entries" | fzf)
    [ -z "$entry" ] && return 

    echo "[+] Connect to '$(echo $entry | cut -d" " -f1)'"

    printf "\e[?2004l"
    eval "TERM=xterm-256color ssh -F /tmp/config $(echo $entry | cut -d" " -f1)"
}

function _s2() {
    local entries=$(pass list | grep "^ssh")
    local entry=$(printf "$entries" | fzf)
    local server port user password cmd

    [ -z "$entry" ] && return 

    cmd=$(pass $entry cmd 2>/dev/null)

    if [ -n "$cmd" ]; then
        printf "\e[?2004l"
        eval "TERM=xterm-256color $cmd"
    else
        password=$(pass $entry password 2>/dev/null)
        [ -z "$password" ] && echo "[-] Entry have not password field" && return

        server=$(pass $entry server 2>/dev/null)
        [ -z "$server" ] && server=$(basename $entry)

        user=$(pass $entry user 2>/dev/null)
        [ -z "$user" ] && echo "[-] Entry have not user field" && return

        port=$(pass $entry port 2>/dev/null)
        [ -z "$port" ] && port="22"

        printf "\e[?2004l"
        eval "TERM=xterm-256color sshpass -p'$password' ssh -4 -o StrictHostKeyChecking=no $user@$server -p$port"
    fi
}

function tunnels-clean {
    # Clean
    # sudo iptables-restore /etc/iptables/iptables.rules
    # IFS=$'\n'
    # for rule in $(sudo iptables-save | grep "REDSOCKS_RULE"); do
    #     echo $rule
    # done
    sudo iptables -t nat -F OUTPUT
    ps -aux | grep "\-D[0-9]\+ -N" | awk -F' ' '{print $2}' | xargs -n1 sudo kill -9 2>/dev/null
    sudo killall redsocks 2>/dev/null
}

functions tunnels() {
    local IFS=$'\n'
    local CONFIG="$HOME/.config/tunnels.conf"
    local FCONFIG="/tmp/tun.conf"
    local REDSOCK_BIN="/usr/sbin/redsocks"
    local REDSOCK_PID="/tmp/redsocks/redsocks.pid"
    local REDSOCK_CONF="/tmp/redsocks/redsocks.conf"

    # Gain privileges
    #while [ "$(whoami)" != "root" ]; do sudo -v; done
    sudo -v
    tunnels-clean
    mkdir -p /tmp/redsocks

    #pm init
    cat /dev/null > $FCONFIG
    
    printf "base {\n\
        log_debug = off;\n\
        log_info = on;\n\
        log = \"file:/tmp/redsocks/redsocks.log\";\n\
        daemon = on;\n\
        redirector = iptables;\n\
    }\n\n" > $REDSOCK_CONF
    
    # Parse Config
    local section=""
    enable=0
    for line in $(cat $CONFIG | sed 's/ *= */=/g'); do
        parseline=$(echo $line | tr -d ' ')
        [[ $parseline =~ '^\[.*\].*$' ]] && enable=0 && section=$(echo $parseline)
        [[ $parseline =~ '^default=True.*$' ]] && enable=1
        echo $enable:$section:$line >> $FCONFIG
        #[ $enable -eq 1 ] && echo $enable:$section:$line >> $FCONFIG
    done
    
    # Activate redsocks
    for tunnel in $(cat $FCONFIG | grep "^1:" | cut -d":" -f2 | sort | uniq | tr -d '[]'); do
        host=$(cat $FCONFIG | grep ":\[$tunnel]:" | cut -d":" -f3-1000 | grep '^host=' | cut -d "=" -f2)
        port=$(cat $FCONFIG | grep ":\[$tunnel]:" | cut -d":" -f3-1000 | grep '^port=' | cut -d "=" -f2)
        conopts=$(cat $FCONFIG | grep ":\[$tunnel]:" | cut -d":" -f3-1000 | grep '^conopts=' | cut -d "=" -f2)
        tunport=$(cat $FCONFIG | grep ":\[$tunnel]:" | cut -d":" -f3-1000 | grep '^tunport=' | cut -d "=" -f2)
        networks=$(cat $FCONFIG | grep ":\[$tunnel]:" | cut -d":" -f3-1000 | grep '^networks=' | cut -d "=" -f2)
        exclude=$(cat $FCONFIG | grep ":\[$tunnel]:" | cut -d":" -f3-1000 | grep '^exclude=' | cut -d "=" -f2)
        check=$(cat $FCONFIG | grep ":\[$tunnel]:" | cut -d":" -f3-1000 | grep '^check=' | cut -d "=" -f2)
        redsocks_port=$(($tunport + 1000))
    
        # Config redsocks
        printf "redsocks {\n\
        local_ip = 127.0.0.1;\n\
        local_port = $redsocks_port;\n\
        ip = 127.0.0.1;\n\
        port = $tunport;\n\
        type = socks5;\n\
    }\n\n" >> $REDSOCK_CONF
    done
    
    # Run redsocks
    sudo -v
    eval "sudo $REDSOCK_BIN -c $REDSOCK_CONF -p $REDSOCK_PID"
    
    # Activate tunnels
    for tunnel in $(cat $FCONFIG | grep "^1:" | cut -d":" -f2 | sort | uniq | tr -d '[]'); do
        host=$(cat $FCONFIG | grep ":\[$tunnel]:" | cut -d":" -f3-1000 | grep '^host=' | cut -d "=" -f2)
        port=$(cat $FCONFIG | grep ":\[$tunnel]:" | cut -d":" -f3-1000 | grep '^port=' | cut -d "=" -f2)
        conopts=$(cat $FCONFIG | grep ":\[$tunnel]:" | cut -d":" -f3-1000 | grep '^conopts=' | cut -d "=" -f2)
        tunport=$(cat $FCONFIG | grep ":\[$tunnel]:" | cut -d":" -f3-1000 | grep '^tunport=' | cut -d "=" -f2)
        networks=$(cat $FCONFIG | grep ":\[$tunnel]:" | cut -d":" -f3-1000 | grep '^networks=' | cut -d "=" -f2)
        exclude=$(cat $FCONFIG | grep ":\[$tunnel]:" | cut -d":" -f3-1000 | grep '^exclude=' | cut -d "=" -f2)
        check=$(cat $FCONFIG | grep ":\[$tunnel]:" | cut -d":" -f3-1000 | grep '^check=' | cut -d "=" -f2)
        redsocks_port=$(($tunport + 1000))
    
        # Iptables
        #local IFS=$' '
        eval "sudo iptables -t nat -I OUTPUT 1 -m comment --comment 'REDSOCKS_RULE' -p tcp -d 127.0.0.1/8 -j RETURN"
        for exc in "${(@s/ /)exclude}"; do
            [ -n "$exc" ] && eval "sudo iptables -t nat -I OUTPUT 2 -m comment --comment 'REDSOCKS_RULE' -p tcp -d $exc -j RETURN"
        done
    
        for net in "${(@s/ /)networks}"; do
            [ -n "$net" ] && eval "sudo iptables -t nat -A OUTPUT -m comment --comment 'REDSOCKS_RULE' -p tcp -d $net -j REDIRECT --to-ports $redsocks_port"
        done
    
        # Run tunnels
        pw=$(pass ssh/$host:$port password)
        if [ $? -eq 0 ]; then
            eval "sshpass -p'$pw' ssh -4 $host -p$port -D$tunport -N &"
        fi
    
        echo "Activating $tunnel"
    done
    
    echo ""
    echo -n "Press enter to exit" && read
    tunnels-clean
    
    return 0
}

# TUNNELS
function zennos() {
    local networks exclude

    networks="$networks 192.168.1.0/24"
    networks="$networks 172.31.13.0/24"
    networks="$networks 172.31.17.0/24"
    networks="$networks 192.168.210.0/24"
    networks="$networks 192.168.99.0/24"
    networks="$networks 192.168.100.0/22"
    networks="$networks 192.168.56.110"
    networks="$networks 192.168.118.0/24"

    exclude="$exclude -x 192.168.1.1"
    exclude="$exclude -x 192.168.1.230"
    exclude="$exclude -x 192.168.1.250"
    exclude="$exclude -x 192.168.1.251"

    eval "sshuttle -r root@192.168.252.25 $networks $exclude"
}
