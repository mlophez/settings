function git-create-random-branch
    set -l random (random 1000000 5000000)
    set -l username miguellopez

    git switch main
    git pull
    git switch -c $username-$random
end
