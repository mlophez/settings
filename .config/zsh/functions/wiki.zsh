#!/usr/bin/zsh


export WIKI_PATH="$HOME/Documents/Notes"

function wiki() {
    cd $WIKI_PATH
    wiki-gen-index
    nvim '+VimwikiIndex 1'
}

function wiki-screenshot() {
    local wait_time="$1"
    local name=$(date +"%s")

    ! type grim  &>/dev/null && return 0
    ! type slurp &>/dev/null && return 0

    if [ -n "$wait_time" ]; then
        notify-send -u low "WSCREENSHOT" "WAIT $wait_time seconds" -t $((wait_time * 999))
        sleep $wait_time
    fi

    if type swappy &>/dev/null; then
        grim -g "$(slurp)" $WIKI_PATH/attachments/${name}.tmp.png
        swappy -f $WIKI_PATH/attachments/${name}.tmp.png -o $WIKI_PATH/attachments/${name}.png
        rm -rf $WIKI_PATH/attachments/*.tmp.png
    else
        grim -g "$(slurp)" $WIKI_PATH/attachments/${name}.png
    fi

    if [ ! -e $WIKI_PATH/attachments/${name}.png ]; then
        warn "WSCREENSHOT" "CANCELLED SCREENSHOT"
        return 0
    fi

    echo "[${name}.png](/attachments/${name}.png)" | clipboard
}

function wiki-gen-index() {
    local title index category
    cd $WIKI_PATH

    find library -type f -name "*.imd" -not -name "*.md" -delete
    printf "# INDEX\n\n" > index.md

    #while read line; do
    #    title=$(echo "$line" | tr '[:lower:]' '[:upper:]')
    #    printf "# ${title}\n\n" > library/$line/${line}.imd
    #    echo "[${title}](/library/$line/${line}.imd)" >> index.md
    #done <<< $(ls library | sort -d)

    while read line; do
        category=$(basename $(echo $line | cut -d"/" -f 1,2) | tr '[:lower:]' '[:upper:]')
        title=$(basename $line | sed 's/\.md//g' | sed 's/-/ /g' | tr '[:lower:]' '[:upper:]')
        index=$(basename $(echo $line | cut -d"/" -f 1,2))

        [ -z "$(cat index.md | grep "^## ${category}$")" ] && echo -e "\n## ${category}" >> index.md
        echo "[${title}](/$line)" >> index.md
    done <<< $(find library -type f -name "*.md" -not -name "*.imd" | sort -d)

    #printf "\n## ALL NOTES\n\n" >> index.md

    #while read line; do
    #    title=$(basename $line | sed 's/\.md//g' | sed 's/-/ /g' | tr '[:lower:]' '[:upper:]')
    #    index=$(basename $(echo $line | cut -d"/" -f 1,2) | tr '[:lower:]' '[:upper:]')
    #    echo "**${index}:** [${title}](/$line)" >> index.md
    #done <<< $(find library -type f -name "*.md" -not -name "*.imd" | sort -d)

    cd - &> /dev/null
}

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
