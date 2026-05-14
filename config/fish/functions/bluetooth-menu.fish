function bluetooth-menu
    set -l bt_status (systemctl --user is-active bluetooth.service 2>/dev/null; or command systemctl is-active bluetooth.service 2>/dev/null)
    if test "$bt_status" = inactive
        sudo systemctl start bluetooth.service
    end

    set -l device (bluetoothctl devices | fzf)
    test -z "$device"; and return 1

    bluetoothctl power on
    bluetoothctl connect (echo $device | cut -d' ' -f2)
end
