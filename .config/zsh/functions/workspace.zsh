#!/usr/bin/zsh


function workspace() {
    local mailpath="$HOME/.local/share/thunderbird/default"

    [[ ! -d "$mailpath" ]] && mkdir -p $mailpath &> /dev/null

    [[ -z "$(pidof alacritty)" ]] && alacritty &!
    [[ -z "$(pidof vivaldi-bin)" ]] && vivaldi-stable &!
    [[ -z "$(pidof keepassxc)" ]] && keepassxc &!
    [[ -z "$(pidof thunderbird)" ]] && thunderbird --profile $HOME/.local/share/thunderbird/default &!
    [[ -z "$(ps -aux | grep vscode-window | grep -v grep)" ]] && /usr/bin/code-oss --new-window &!

    rm -rf $HOME/.thunderbird/ &> /dev/null
}
