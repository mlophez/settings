function pass-menu
    set -l entries (pass list)
    set -l entry (printf '%s\n' $entries | fzf)
    test -z "$entry"; and return 0

    if test -z "$argv[1]"
        pass $entry
    else
        pass edit $entry
    end
end
