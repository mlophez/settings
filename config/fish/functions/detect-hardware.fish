function detect-hardware
    printf '%s\n' \
        'echo "[+] Enabling detecting..."' \
        'sysctl -w kernel.overflowuid=0' \
        'echo "[+] Connect your hardware. Press any key for disabling..."' \
        'read -r input' \
        'sysctl -w kernel.overflowuid=65534' \
        > /tmp/detect-hardware.sh
    chmod 755 /tmp/detect-hardware.sh
    distrobox-host-exec sudo bash /tmp/detect-hardware.sh
end
