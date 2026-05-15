function workspace
    set -l dirs
    for base in $HOME/Code $HOME/Documents/Code
        if test -d $base
            if command -q fd
                set dirs $dirs (fd --min-depth 1 --max-depth 1 --type d --type l . $base 2>/dev/null)
                set dirs $dirs (fd --hidden --no-ignore --max-depth 3 --type d '^\.git$' $base --exec dirname 2>/dev/null)
            else
                set dirs $dirs (find $base -mindepth 1 -maxdepth 1 -type d -o -type l 2>/dev/null)
                set dirs $dirs (find $base -mindepth 1 -maxdepth 3 -type d -name .git 2>/dev/null | xargs -I@ dirname @)
            end
        end
    end

    set dirs (string trim --right --chars=/ -- $dirs)

    set -l selected
    if command -q tv
        set selected (printf '%s\n' $dirs | sort -u | tv)
    else
        set selected (printf '%s\n' $dirs | sort -u | fzf)
    end
    test -z "$selected"; and return 0

    cd $selected
    set -gx WORKSPACE (pwd)

    test -n "$TMUX"; and tmux rename-window (basename $selected | string upper)
    test -n "$ZELLIJ"; and zellij action rename-tab (basename $selected | string upper)
end
