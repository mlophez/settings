#!/usr/bin/zsh

function pass {
    local commands=("init" "ls" "grep" "find" "show" "insert" "edit" "generate" "rm" "mv" "cp" "git" "otp")
    local args=("${@[@]}")
    local pos=()
    local clip=false
    local rc

    while [[ $# -gt 0 ]]; do
        case $1 in
            -c|--clip)
                clip=true
                shift
                ;;
            -*)
                shift
                ;;
            *)
                pos+=("$1")
                shift
                ;;
        esac
    done

    set -- "${args[@]}"

    if [[ "$1" = "list" ]]; then
        find $PASSWORD_STORE_DIR -type f,l -name \*.gpg | sed "s#$PASSWORD_STORE_DIR/*##g" | sed 's/\.gpg$//g'
    elif [[ "${commands[@]}" =~ "$1" ]]; then
        command pass "$@"
    else
        if [ -z "$pos[2]" ]; then
            command pass "$@"
        else
            if [ "$pos[2]" = "password" ]; then
                rc=$(pass "$pos[1]" | head -1)
                [ -z "$rc" ] && return 1
                [ "$clip" = "true" ] && echo $rc | clipboard && return 0
                echo $rc
            elif [ "$pos[2]" = "otpauth" ] || [ "$pos[2]" = "otp" ]; then
                if [ "$clip" = "true" ]; then
                    command pass otp -c "$pos[1]"
                else
                    command pass otp "$pos[1]"
                fi
            else
                rc=$(pass "$pos[1]" | grep "^$pos[2]:" | sed "s/^$pos[2]: *//g" | tr '\n' ' ' | sed 's/ *$//g')
                [ -z "$rc" ] && return 1
                [ "$clip" = "true" ] && echo $rc | clipboard && return 0
                echo $rc
            fi
        fi
    fi
}

function pass_menu() {
    local entries=$(pass list)
    local entry=$(printf "$entries" | fzf)
    [ -z "$entry" ] && return

    eval "pass $entry"
}

function pass_menu_edit() {
    local entries=$(pass list)
    local entry=$(printf "$entries" | fzf)
    [ -z "$entry" ] && return

    eval "pass edit $entry"
}

# Grupo,Titulo,Usuario,Contraseña,URL,Notas,OTP
function pass2csv() {
    local group title user password url notes otp
    for i in $(pass list); do
        group=$(dirname $i | tr '[:lower:]' '[:upper:]')
        title=$(basename $i | tr '[:lower:]' '[:upper:]')
        user=$(pass $i user 2> /dev/null)
        password=$(pass $i password 2> /dev/null)
        url=$(pass $i url 2> /dev/null)
        otp=$(pass $i | grep ^otpauth 2> /dev/null)
        notes=$(pass $i | tr '\n' ' ')

        [ "$group" = "." ] && group="ROOT"

        echo "|$group|,|$title|,|$user|,|$password|,|$url|,|$notes|,|$otp|"

        #break
    done
}


