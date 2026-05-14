function git-identity
    set -l email (printf "miguel.lr96@gmail.com\nmiguel.lopez@logalty.com\n" | fzf)
    test -z "$email"; and return 0
    git config user.name "Miguel López Ruiz"
    git config user.email $email
end
