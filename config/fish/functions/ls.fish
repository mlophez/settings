function ls
    if type -q lsd
        command lsd -v --group-directories-first $argv
    else if type -q eza
        command eza --group-directories-first $argv
    else
        command ls -v --color $argv
    end
end
