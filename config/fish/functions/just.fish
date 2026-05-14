function just
    set -l opts
    if test (count $argv) -eq 0
        set opts -u --choose
    end

    if test (pwd) = $HOME
        command just $opts --unstable --justfile $HOME/.config/just/justfile --working-directory . $argv
    else
        command just --unstable $argv
    end
end
