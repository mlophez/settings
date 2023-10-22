#!/usr/bin/zsh

function notes() {
  cd $HOME/Documents/Notes
  [ -n "$TMUX" ]   && tmux rename-window "NOTES"
  [ -n "$ZELLIJ" ] && zellij action rename-tab "2# NOTES"
  nvim inbox.md
}

# NOTES
# function notes() {
#   local notespath="$HOME/Documents/Wiki"
#   local repository=""
#
#   [ "$notespath/pages" ] && mkdir -p "$notespath/pages" &>/dev/null
#   [ "$notespath/assets" ] && mkdir -p "$notespath/assets" &>/dev/null
#
#   [ -n "$TMUX" ] && tmux rename-window 'NOTES'
#
#   # Run NeoVim
#   cd $notespath
#   [ -d ".git/" ] && git pull
#   nvim index.md
#   [ -d ".git/" ] && git status
#
#   # Save changes
#   #[ -n "$(git status | grep -i untracked)" ] && \
#   #[ -d ".git/" ] && \
#   #  git add . && \
#   #  git commit -m "$(date '+%Y-%m-%d %H:%M:%S')" && \
#   #  git push -u origin main
# }

