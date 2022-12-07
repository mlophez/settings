#!/usr/bin/zsh

alias g="git"
alias add="git add . && git status"
alias commit="git commit -m \"$(date '+%Y-%m-%d %H:%M:%S')\""
alias push="git push -u origin main"
alias pull="git pull"
alias undo="git reset --soft HEAD~1"


