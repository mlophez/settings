function java-menu
    set -l entry (archlinux-java status | grep '^ ' | string trim | cut -d' ' -f1 | fzf)
    test -z "$entry"; and return 0
    sudo archlinux-java set $entry
end
