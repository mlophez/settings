function curl
    if type -q curlie
        curlie $argv
    else
        command curl $argv
    end
end
