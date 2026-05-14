function aws-profile-menu
    set -l profile (cat $HOME/.aws/config | grep -v '^ *#' | grep -o '\[ *profile .*\]' | sed 's/\]//g' | cut -d' ' -f2 | fzf)
    test -z "$profile"; and return 0
    set -gx AWS_PROFILE $profile
end
