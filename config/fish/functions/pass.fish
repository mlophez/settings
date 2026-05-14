function pass
    set -l commands init ls grep find show insert edit generate rm mv cp git otp
    set -l pos
    set -l clip false

    for arg in $argv
        switch $arg
            case -c --clip
                set clip true
            case '-*'
                true
            case '*'
                set pos $pos $arg
        end
    end

    if test "$argv[1]" = list
        find $PASSWORD_STORE_DIR -type f,l -name '*.gpg' \
            | sed "s#$PASSWORD_STORE_DIR/*##g" \
            | sed 's/\.gpg$//g'
    else if contains -- $argv[1] $commands
        command pass $argv
    else if test -z "$pos[2]"
        command pass $argv
    else
        switch $pos[2]
            case password
                set -l rc (command pass $pos[1] | head -1)
                test -z "$rc"; and return 1
                if test "$clip" = true
                    echo $rc | clipboard
                    return 0
                end
                echo $rc
            case otpauth otp
                if test "$clip" = true
                    command pass otp -c $pos[1]
                else
                    command pass otp $pos[1]
                end
            case '*'
                set -l rc (command pass $pos[1] | grep "^$pos[2]:" | sed "s/^$pos[2]: *//g" | tr '\n' ' ' | string trim)
                test -z "$rc"; and return 1
                if test "$clip" = true
                    echo $rc | clipboard
                    return 0
                end
                echo $rc
        end
    end
end
