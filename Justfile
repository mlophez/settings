# Help
[private]
help:
  @just -u -l

install:
  nix run home-manager/master -- --extra-experimental-features "nix-command flakes" switch --flake .#macos --impure

switch: && clean
  home-manager --extra-experimental-features "nix-command flakes" switch --flake .#macos --impure --show-trace

packages:
  home-manager --extra-experimental-features "nix-command flakes" packages --flake .#macos  --impure

news:
  home-manager --extra-experimental-features "nix-command flakes" news --flake .#macos  --impure

upgrade: && switch clean
  nix flake update

clean:
  nix-collect-garbage --delete-old

build:
  #!/bin/bash
  DATE=$(date '+%Y%m%d')
  podman build -t workstation:${DATE} .
  podman tag workstation:latest workstation:backup
  podman tag workstation:${DATE} workstation:latest
  podman image prune

configure:
  #!/bin/bash
  install () {
    local src=$1
    local dest=$2
    [[ -d $dest ]] && rm -r $dest
    [[ -f $dest ]] && rm $dest
    echo $src - $dest
    mkdir -p $(dirname $dest)
    ln -sf $src $dest
  }
  install $(pwd) $HOME/.local/share/settings
  install $(pwd)/config/wezterm $HOME/.config/wezterm
  install $(pwd)/config/zsh $HOME/.config/zsh
  install $(pwd)/config/zsh/zshrc $HOME/.zshrc
  install $(pwd)/config/zsh/zshenv $HOME/.zshenv
  install $(pwd)/config/zsh/zprofile $HOME/.zprofile
  install $(pwd)/config/starship.toml $HOME/.config/starship.toml
  install $(pwd)/config/zellij $HOME/.config/zellij
  install $(pwd)/config/tmux $HOME/.config/tmux
  install $(pwd)/config/nix $HOME/.config/nix
  install $(pwd)/config/git $HOME/.config/git
  install $(pwd)/config/k9s $HOME/.config/k9s
  install $(pwd)/config/kube/config $HOME/.config/kube/config
  install $(pwd)/config/aws/config $HOME/.aws/config
  install $(pwd)/config/ssh/config $HOME/.ssh/config

netskope:
  mkdir -p $HOME/.local/share/certificates
  echo | openssl s_client -connect oidc.eu-west-1.amazonaws.com:443 -servername oidc.eu-west-1.amazonaws.com 2>/dev/null | openssl x509 -outform PEM > $HOME/.local/share/certificates/netskope.crt
