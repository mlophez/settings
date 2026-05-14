function ssh-menu
    set -l entries (cat $HOME/.ssh/config | grep -i '^Host' | grep -v '*' | string replace -ra ' +' ' ' | cut -d' ' -f2- | sort)
    set -l entry (printf '%s\n' $entries | fzf)
    test -z "$entry"; and return 0

    set -l hook
    if test -e $HOME/.ssh/credentials
        set -l profile (cat $HOME/.ssh/credentials | cut -d'|' -f1 | fzf)
        if test -n "$profile"; and test "$profile" != NONE
            set hook "sshpass -p'"(cat $HOME/.ssh/credentials | grep "^$profile" | cut -d'|' -f2)"'"
        end
    end

    echo "[+] Connect to '"(echo $entry | cut -d' ' -f1)"'"
    TERM=xterm-256color eval "$hook ssh "(echo $entry | cut -d' ' -f1)
end
