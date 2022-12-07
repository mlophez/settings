#!/usr/bin/zsh

function gic() {
    command git --git-dir=$HOME/.local/git --work-tree=$HOME "$@"
}

function status() {
    gic restore --staged .
    gic add $HOME/.config/zsh \
            $HOME/.config/nvim \
            $HOME/.config/tmux \
            $HOME/.config/alacritty \
            $HOME/.config/git \
            $HOME/.config/qtile \
            $HOME/.config/waybar \
            $HOME/.config/sway \
            $HOME/.config/mutt \
            $HOME/.config/systemd \
            $HOME/.config/mako \
            $HOME/.config/zsh \
            $HOME/.config/containers \
            $HOME/.config/i3 \
            $HOME/.config/gnupg \
            $HOME/.local/share/applications/archlinux.desktop \
            $HOME/.local/share/fonts \
            $HOME/.ssh/config \
            $HOME/.bashrc \
            $HOME/.gitignore

    gic status
}

function save() {
    gic commit -m "$(date '+%Y-%m-%d %H:%M:%S')"
    gic push -u origin main
}

function load() {
    gic pull
}

function run_wsl_install() {
    #[ "$(whoami)" != "root" ] && echo "Run as a root" && return -1

    sudo bash <<EOF
apt install zsh tmux neovim fzf unzip
cat $HOME/.config/zsh/resources/wsl/wsl.conf > /etc/wsl.conf
cat $HOME/.config/zsh/resources/wsl/wslboot.sh > /usr/local/bin/wslboot
chmod 755 /usr/local/bin/wslboot

curl -sLo /tmp/win32yank.zip https://github.com/equalsraf/win32yank/releases/download/v0.0.4/win32yank-x64.zip
unzip -p /tmp/win32yank.zip win32yank.exe > /usr/local/bin/win32yank.exe
chmod +x /usr/local/bin/win32yank.exe
EOF
}

function run_wsl_config() {
    # Set download in windows 11
    #! test -L $HOME/Downloads && ln -sf /mnt/c/Users/miguel.lopez.logalty/Downloads $HOME/Downloads
    cp $HOME/.config/alacritty/alacritty.yml /tmp/alacritty.yml 
    sed 's#program:.*$#program: "C:/Windows/System32/wsl.exe"\n  args:\n    - --cd ~#g' -i /tmp/alacritty.yml
    cp /tmp/alacritty.yml /mnt/c/Users/miguel.lopez.logalty/AppData/Roaming/alacritty/alacritty.yml
}

function run_arch_install() {
  local packagefile="$HOME/.config/zsh/resources/toolbox/archlinux.packages"
  sudo pacman --needed -S $(cat $packagefile | grep -v "^ *#" | grep -v "^ *$" | tr "\n" " ")
}

function run_toolbox_config() {
}
