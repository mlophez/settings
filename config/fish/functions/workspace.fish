function workspace
    set -l dirs
    for base in $HOME/Code $HOME/Documents/Code
        if test -d $base
            set dirs $dirs (find $base -mindepth 1 -maxdepth 1 -type d -o -type l 2>/dev/null)
            set dirs $dirs (find $base -mindepth 1 -maxdepth 3 -type d -name .git 2>/dev/null | xargs -I@ dirname @)
        end
    end

    set -l selected (printf '%s\n' $dirs | sort -u | fzf)
    test -z "$selected"; and return 0

    cd $selected
    set -gx WORKSPACE (pwd)

    test -n "$TMUX"; and tmux rename-window (basename $selected | string upper)
    test -n "$ZELLIJ"; and zellij action rename-tab (basename $selected | string upper)
end
