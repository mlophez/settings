function goproject --description 'Pick a project from $HOME/Code and cd into it'
    set -l dirs
    for base in $HOME/Code $HOME/Documents/Code
        if test -d $base
            if command -q fd
                set dirs $dirs (fd --hidden --no-ignore --max-depth 2 --type d '^\.git$' $base --exec dirname 2>/dev/null)
            else
                set dirs $dirs (find $base -mindepth 1 -maxdepth 2 -type d -name .git 2>/dev/null | xargs -I@ dirname @)
            end
        end
    end

    set dirs (string trim --right --chars=/ -- $dirs)

    set -l tab (printf '\t')
    set -l pairs (printf '%s\n' $dirs | sort -u | awk -v t=$tab -v home="$HOME" '{
        rel = $0
        sub(home "/Documents/Code/", "", rel)
        sub(home "/Code/", "", rel)
        print toupper(substr(rel,1,1)) substr(rel,2) t $0
    }')

    set -l selected
    if command -q tv
        set selected (printf '%s\n' $pairs | tv --source-display "{split:$tab:0}" --source-output "{split:$tab:1}")
    else
        set selected (printf '%s\n' $pairs | fzf --with-nth=1 -d \t | cut -f2)
    end
    test -z "$selected"; and return 0

    cd $selected
    set -gx WORKSPACE (pwd)

    test -n "$TMUX"; and tmux rename-window (basename $selected | string upper)
    test -n "$ZELLIJ"; and zellij action rename-tab (basename $selected | string upper)
end
