function pip
    if test "$argv[1]" = install
        command pip $argv --break-system-packages
    else
        command pip $argv
    end
end
