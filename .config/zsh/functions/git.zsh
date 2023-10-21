#!/usr/bin/zsh

alias g="git"
alias gm="git_menu"
alias wk="workspace"
alias ck="workspace move"
alias git-id-personal="git config user.name 'Miguel López Ruiz' && git config user.email 'miguel.lr96@gmail.com'"
alias git-id-logalty="git config user.name 'Miguel López Ruiz' && git config user.email 'miguel.lopez@logalty.com'"

# GIT
function git_menu() {
  local cmd
  local opts=(
    "undo: git reset --soft HEAD~1"
    "fetch: git fetch -p -P"
    "main: git checkout main"
    "clean: git checkout main && git branch | grep -v 'main' | xargs -I@ git branch -D @"
    "pull: git pull"
    "push: git push"
    'datecommit: git commit -m "$(date "+%Y-%m-%d %H:%M:%S")"'
    'add: git add . && git status'
    'discard: git restore .'
    'branch-create: git_branch_create'
    'branch-random: git_generate_random_branch'
    'save: git add . && git commit -m "Commit on '"'"'$(date "+%Y-%m-%d %H:%M:%S")'"'"'" && git push'
    'branch-delete: branch=$(git branch | sed "s/[ \*]//g" | fzf); git branch -D $branch'
    'tag-upload: git push --tags'
    'tag-delete: tag=$(git tag | fzf); git tag -d $tag; git push --delete origin $tag'
  )

  cmd=$(printf '%s\n' "${opts[@]}" | fzf --layout=default)
  [ -z "$cmd" ] && return 0

  echo "-> $cmd"
  eval "$(echo $cmd | cut -d ":" -f 2-100000000 | sed 's/^ *//g')"
}

function git_generate_random_branch() {
  local random=$[ $RANDOM % 5000000 + 1000000 ]
  local username="miguellopez"

  git checkout main
  git pull

  git checkout -b $username-$random
  git push --set-upstream origin $username-$random
}

function git_branch_create() {
  echo -n "Branch name?: "
  read name
  if [ -n "$name" ]; then
    git checkout -b $name
    git push --set-upstream origin $name
  fi
}


