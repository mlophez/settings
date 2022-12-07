#!/usr/bin/zsh

alias vi="editor"
alias vim="editor"
alias nvim="editor"

function editor() {
    #export TERM=xterm-256color
    command nvim "$@"
}
