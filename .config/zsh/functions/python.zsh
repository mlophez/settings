#!/bin/zsh

function activate () {
    local venvpath="$1"

    unset PYTHONPATH
    source $venvpath/bin/activate
}
