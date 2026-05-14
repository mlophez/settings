function cc
    set -l dir (find . -type d -print | fzf)
    test -n "$dir"; and cd $dir
end
