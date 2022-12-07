#!/usr/bin/zsh

function mail-sync() {
    # ACCOUNTS
    
    #[ ! -d $HOME/.local/mail/trc ] && mkdir -p $HOME/.local/mail/trc
    #[ ! -d $HOME/.local/mail/gmail ] && mkdir -p $HOME/.local/mail/gmail
    #[ ! -d $HOME/.local/mail/hotmail ] && mkdir -p $HOME/.local/mail/hotmail
    # mbsync -c $HOME/.config/mutt/config/mbsyncrc -a 2>&1 | tee -a /tmp/$USER/mbsync.log
    # mbsync -c $HOME/.config/mutt/config/mbsyncrc $account 2>&1 | tee -a /tmp/$USER/mbsync.log

    while true; do
        echo "SYNCING"
        echo "1" > /tmp/$USER/mbsync.status
        for account in $(cat $HOME/.config/mutt/config/mbsyncrc | grep "^Account" | cut -d" " -f 2); do
            [ ! -d $HOME/.local/share/mail/$account ] && mkdir -p $HOME/.local/share/mail/$account
            mbsync -c $HOME/.config/mutt/config/mbsyncrc $account
            [ $? -ne 0 ] && critical "MAIL" "Error to syncronize imap mailboxes."
        done
        echo "0" > /tmp/$USER/mbsync.status
        echo "WAITING"
        #if [ -e "$HOME/.config/mutt/config/mbsyncrc.$HOSTNAME" ]; then
        #    mbsync -c $HOME/.config/mutt/config/mbsyncrc.$HOSTNAME -a &>/tmp/$USER/mbsync.log
        #else
        #fi
        sleep 60
    done
}

function mail-sync-stop() {
    while true; do
        if [ "$(cat /tmp/$USER/mbsync.status)" -eq 0 ]; then
            pkill -9 -f 'mail-sync'
            break
        fi
        sleep 3
    done
}

function mailboxes() {
    local MAILDIR=$1
    local mailboxes

    mailboxes=$(find $MAILDIR/ -maxdepth 1 -type d -printf "=%f\n" | grep -i "Inbox" | sort | tr '\n' ' ')
    mailboxes="$mailboxes $(find $MAILDIR/ -maxdepth 1 -type d -printf "=%f\n" | tail -n +2 | grep -vi "Inbox" | sort | tr '\n' ' ')"

    echo $mailboxes
}

function oauth2google-setup() {
    local client_id="775395676873-5dhbp1nktkd60i11g9c2a2nud0arpiim.apps.googleusercontent.com"
    local client_secret="9_VXDouGJ-kNublS3IZYs2Ul"

    #local scope="https://mail.google.com"
    #local url="https://accounts.google.com/o/oauth2/auth?client_id=$client_id&redirect_uri=urn:ietf:wg:oauth:2.0:oob&scope=$scope&response_type=code"
    #eval "vivaldi-stable '$url'"

    # Refresh token
    data="code=$code&client_id=$client_id&client_secret=$client_secret&redirect_uri=urn:ietf:wg:oauth:2.0:oob&grant_type=authorization_code"
    curl --request POST --data "$data" https://accounts.google.com/o/oauth2/token

    #local code="$(pass $store client_code)"
    echo "CODE: $code"
    echo "REFRESH_TOKEN: $refresh_token"
}

function oauth2google() {
    local resp data
    # https://console.developers.google.com/
    local client_id="775395676873-5dhb....p1nktkd60i11g9c2a2nud0arpiim.apps.googleusercontent.com"
    local client_secret="9_VXDouGJ-kNublS....3IZYs2Ul"

    # Setup
    local code="4/1AY0e-g4_VtKsRl...iRfhbrxPCDduFjddEieT2XNg5groXVhA"
    local refresh_token="1//03s9MAK....GAMSNwF-L9IrPPLiKpQQeqxX1KvTMqpJ__dk4tYItBYWwFXffNKazHZ0XacHyC-0wurLgFceh8KFnMo"
    
    ##  #4) refresh if needed
    data="client_id=$client_id&client_secret=$client_secret&refresh_token=$refresh_token&grant_type=refresh_token"
    token=$(curl -s --request POST --data "$data" https://accounts.google.com/o/oauth2/token | jq -r .access_token)
    [ "$token" = "null" ] && echo "" && return 1
    
    # GET STATUS OF TOKEN
    # curl "https://www.googleapis.com/oauth2/v1/tokeninfo?access_token=$token"
    
    echo $token
}

function pass-oauth2() {
    local store=$1
    local client_id="$(pass $store client_id)"
    local client_secret="$(pass $store client_secret)"
    local refresh_token="$(pass $store refresh_token)"

    data="client_id=$client_id&client_secret=$client_secret&refresh_token=$refresh_token&grant_type=refresh_token"
    token=$(curl -s --request POST --data "$data" https://accounts.google.com/o/oauth2/token | jq -r .access_token)
    [ "$token" = "null" ] && echo "" && return 1
    echo $token
}

function mail() {
    #[ -z "$(ps aux | grep -i mail-sync | grep -v grep)" ] && mail-sync &
    [ -n "$TMUX" ] && tmux rename-window MAIL
    neomutt
    #fg
}

function mail-thunderbird() {
    rm -rf $HOME/.thunderbird &> /dev/null
    mkdir -p $HOME/.config/thunderbird/default &> /dev/null
    mkdir -p $HOME/.local/share/mail &> /dev/null

    local msf=$(find $HOME/.config/thunderbird/default/ -name "*.msf" | wc -l)
    [ $msf -ne 0 ] && warn "Thunderbird" "Found files msf in config folder"


    command thunderbird --profile $HOME/.config/thunderbird/default
}
