function notes
    set -l notedir $HOME/Notes

    cd $notedir

    test -n "$TMUX"; and tmux rename-window NOTES
    test -n "$ZELLIJ"; and zellij action rename-tab NOTES

    nvim
end
