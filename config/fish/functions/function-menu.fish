function function-menu
    set -l func (ls $HOME/.config/fish/functions/ | string replace '.fish' '' | fzf)
    test -z "$func"; and return 0
    commandline -r $func
end
