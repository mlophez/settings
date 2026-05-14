function pass2csv
    for i in (pass list)
        set -l group (dirname $i | string upper)
        set -l title (basename $i | string upper)
        set -l user (pass $i user 2>/dev/null)
        set -l password (pass $i password 2>/dev/null)
        set -l url (pass $i url 2>/dev/null)
        set -l otp (pass $i | grep '^otpauth' 2>/dev/null)
        set -l notes (pass $i | tr '\n' ' ')

        test "$group" = .; and set group ROOT

        echo "|$group|,|$title|,|$user|,|$password|,|$url|,|$notes|,|$otp|"
    end
end
