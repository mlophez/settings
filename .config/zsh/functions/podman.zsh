#!/usr/bin/zsh

function podman-install() {
    if [ ! -e "/usr/local/bin/podman" ]; then
        echo "[+] Installing..."
        sudo bash << EOF
sudo printf "#!/bin/bash\nsudo /usr/bin/podman \"\$@\"\n" > /usr/local/bin/podman
sudo printf "#!/bin/bash\nsudo /usr/bin/podman \"\$@\"\n" > /usr/local/bin/docker
sudo printf "#!/bin/bash\nsudo /usr/bin/buildah \"\$@\"\n" > /usr/local/bin/buildah
EOF
        sudo chmod 755 /usr/local/bin/*
    fi
}
