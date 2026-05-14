function __dot_git
    pushd $HOME/.local/share/settings >/dev/null
    command git $argv
    set -l ret $status
    popd >/dev/null
    return $ret
end

function __dot_status
    __dot_git pull
    __dot_git restore --staged . 2>/dev/null

    if test -e "$KUBECONFIG"
        sed 's/current-context:.*$/current-context: none/g' -i $KUBECONFIG
    end

    __dot_git add .
    __dot_git status
end

function __dot_save
    set -l ts (date '+%Y-%m-%d %H:%M:%S')
    __dot_git commit -m "Commit on '$ts'"
    __dot_git push -u origin main
end

function dot
    switch $argv[1]
        case changes
            __dot_status
        case save
            __dot_save
        case load
            __dot_git pull
        case '*'
            __dot_git $argv
    end
end
