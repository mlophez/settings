#!/usr/bin/zsh

export NOTESPATH="$HOME/Documents/Obsidian"

function notes() {
    #shell "notes-sync" &>/dev/null
    obsidian
    #shell "notes-sync" &>/dev/null
}

function notes-sync() {
    local git_status

    export GIT_ASKPASS=/tmp/gitsync

    [ ! -d "$NOTESPATH/.git" ] && echo "[-] Not found git repository in $NOTESPATH" && return -1

    cd $NOTESPATH
    git config user.name MLR96
    echo -e '#!/usr/bin/zsh -i\npass web/github token' > $GIT_ASKPASS
    chmod 755 $GIT_ASKPASS

    git_status=$(git status -s)
    if [ -n "$git_status" ]; then
        git add -A
        git commit -m "Autocommit $HOSTNAME / $(date '+%Y-%m-%d %H:%M:%S')"
    else
        git pull --rebase
    fi

    [ $(git ls-files -u | wc -l) -ne 0 ] && echo "Conflicto detectado" && /bin/bash
    git push

    echo "Pulse [ENTER] para continuar"
    read
}

function notes-format() {
    for file in $(find $NOTESPATH -type f -print0 | tr ' ' '<space>'); do
        echo $file
    done
}
