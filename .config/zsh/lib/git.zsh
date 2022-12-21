#!/usr/bin/zsh

alias g="git"
alias add="git add . && git status"
alias commit="git commit -m \"$(date '+%Y-%m-%d %H:%M:%S')\""
alias push="git push -u origin main"
alias pull="git pull"
alias undo="git reset --soft HEAD~1"
alias fetch="git fetch -p -P"
alias discard="git restore ."
alias checkout="git checkout"
alias clean="git checkout main && git branch | grep -v 'main' | xargs -I@ git branch -D @"

function branch() {
  local random=$[ $RANDOM % 5000000 + 1000000 ]
  local username="miguellopez"

  git checkout main
  git pull

  git checkout -b $username-$random
  git push --set-upstream origin $username-$random
}



