function git-menu
    set -l options \
        undo \
        fetch \
        main \
        clean \
        pull \
        push \
        datecommit \
        add \
        discard \
        branch-create \
        branch-random \
        save \
        branch-delete \
        tag-upload \
        tag-delete

    set -l choice (printf '%s\n' $options | fzf --layout=default)
    test -z "$choice"; and return 0

    echo "-> $choice"
    switch $choice
        case undo
            git reset --soft HEAD~1
        case fetch
            git fetch -p -P
        case main
            git checkout main
        case clean
            git checkout main
            git branch | grep -v main | xargs -I@ git branch -D @
        case pull
            git pull
        case push
            git push
        case datecommit
            git commit -m (date '+%Y-%m-%d %H:%M:%S')
        case add
            git add .
            git status
        case discard
            git restore .
        case branch-create
            git-create-branch
        case branch-random
            git-create-random-branch
        case save
            set -l ts (date '+%Y-%m-%d %H:%M:%S')
            git add .
            git commit -m "Commit on '$ts'"
            git push
        case branch-delete
            set -l branch (git branch | string trim | grep -v '^\*' | fzf)
            test -n "$branch"; and git branch -D $branch
        case tag-upload
            git push --tags
        case tag-delete
            set -l tag (git tag | fzf)
            if test -n "$tag"
                git tag -d $tag
                git push --delete origin $tag
            end
    end
end
