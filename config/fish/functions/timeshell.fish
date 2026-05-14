function timeshell
    set -l shell $argv[1]
    test -z "$shell"; and set shell $SHELL
    for i in (seq 1 10)
        time $shell -i -c exit
    end
end
