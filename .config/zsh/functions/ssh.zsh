#!/usr/bin/zsh

alias s="ssh_menu"

# SSH
function ssh() {
  printf "\e[?2004l"
  command ssh "$@"
}

function ssh-legacy() {
    #printf "\e[?2004l"
    command ssh -oKexAlgorithms=+diffie-hellman-group1-sha1 $@
}

function ssh_menu() {
    local entries entry
    local profile hook

    entries=$(cat $HOME/.ssh/config | grep -i "^Host" | grep -v "*" | sed 's/ \+/ /g' | cut -d" " -f2-100000 | sort)
    entry=$(printf "$entries" | fzf)
    [ -z "$entry" ] && return

    # Password
    if [ -e $HOME/.ssh/credentials ]; then
      profile=$(cat $HOME/.ssh/credentials | cut -d'|' -f 1 | fzf)
      if [ -n "$profile" -a "${profile}" != "NONE" ];  then
        hook="sshpass -p'$(cat $HOME/.ssh/credentials | grep ^$profile | cut -d'|' -f 2)'"
      fi
    fi

    echo "[+] Connect to '$(echo $entry | cut -d" " -f1)'"

    #printf "\e[?2004l"
    eval "$hook ssh $(echo $entry | cut -d" " -f1)"
}

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


