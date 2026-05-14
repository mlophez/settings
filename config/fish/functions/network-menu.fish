function network-menu
    set -l connection (nmcli -g name connection show | grep -v '^lo' | fzf)
    test -z "$connection"; and return 0
    nmcli connection up $connection --ask
end
