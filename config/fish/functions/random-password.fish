function random-password
    set -l length $argv[1]
    test -z "$length"; and set length 18
    openssl rand -base64 $length
end
