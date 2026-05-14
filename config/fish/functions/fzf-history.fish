function fzf-history
    set -l cmd (history | fzf --no-sort --exact)
    test -n "$cmd"; and commandline -r $cmd
end
