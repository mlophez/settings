function edit
    set -l file (find . -type f -print | fzf)
    test -n "$file"; and nvim $file
end
