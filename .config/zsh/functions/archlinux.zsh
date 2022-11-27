#!/usr/bin/zsh

[ "$DISTRO" != "ARCHLINUX" ] && return

alias install="sudo pacman --needed -S"
alias uninstall="sudo pacman -Rns"
alias update="sudo reflector --verbose --latest 20 --sort rate --protocol https --save /etc/pacman.d/mirrorlist"

function upgrade() {
    sudo pacman -Syu
    type yay &> /dev/null && yay -Syua
    sudo pacman -Scc
}

function setup() {
    local version

    # PYTHONs
    #pip install --prefix=$PYTHONCFG dateutil
    #pip install pyodbc

    # NPM
    #npm -g install selenium-side-runner
    #npm -g install chromedriver
    #npm -g update 
    
    # RUST (falta instalar tookit if do not exists)
    #rustup update

    # APPIMAGE
    # wget https://github.com/liberavia/geforcenow/releases/download/v0.3.0/GeForce.NOW-0.3.0.AppImage

    # NVIM

    # CHROMIUM
    # echo "--force-device-scale-factor=1.2" > $HOME/.config/chromium-flags.conf
    
    # TERRAFORM   
    
    # K8S
    ## KUBECTL
    # version=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
    # curl -L "https://storage.googleapis.com/kubernetes-release/release/$version/bin/linux/amd64/kubectl" -o $HOME/.local/bin/kubectl
    # chmod 755 $HOME/.local/bin/kubectl

    ## KUBECTL COLORS
    #if [ ! -e "$HOME/.local/bin/kubecolor" ]; then
    #    mkdir -p /tmp/kubecolor
    #    curl -s "https://github.com/dty1er/kubecolor/releases/download/v0.0.20/kubecolor_0.0.20_Linux_x86_64.tar.gz" -o /tmp/kubecolor/kubecolor.tar.gz
    #    tar -xf /tmp/kubecolor/kubecolor.tar.gz -C /tmp/kubecolor
    #    cp -rf /tmp/kubecolor/kubecolor $HOME/.local/bin/kubecolor
    #    chmod 755 $HOME/.local/bin/kubecolor
    #    rm -rf /tmp/kubecolor &> /dev/null
    #fi

    ## HELM
    # https://github.com/helm/helm/releases
    # https://get.helm.sh/helm-v3.7.0-linux-amd64.tar.gz

    ## KUBESELECT
    #curl -s "https://raw.githubusercontent.com/fatliverfreddy/kubeselect/master/kubeselect" -o $HOME/.local/bin/kubeselect
    #chmod 755 $HOME/.local/bin/kubeselect

    ## MINIKUBE
    # curl -L https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 -o $HOME/.local/bin/minikube
    # chmod 755 $HOME/.local/bin/minikube

    ## STERN
    #version=$(curl -s "https://github.com/wercker/stern/releases/latest" | sed 's#.*tag/\(.*\)".*#\1#g')
    #curl -s "https://github.com/wercker/stern/releases/download/$version/stern_linux_amd64" -o $HOME/.local/bin/stern
    #chmod 755 $HOME/.local/bin/stern

    ## K0S
    
    ## LENS
    # curl -s -L "https://api.k8slens.dev/binaries/Lens-5.2.4-latest.20210923.1.x86_64.AppImage" -o $HOME/.local/bin/Lens-5.2.4-latest.20210923.1.x86_64.AppImage
    # chmod 755 $HOME/.local/bin/Lens-5.2.4-latest.20210923.1.x86_64.AppImage
}
