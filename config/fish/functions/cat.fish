function cat
    if type -q bat
        command bat $argv
    else
        command cat $argv
    end
end
