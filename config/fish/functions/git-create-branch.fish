function git-create-branch
    read -P "Branch name?: " name
    if test -n "$name"
        git checkout -b $name
        git push --set-upstream origin $name
    end
end
