help:
  just -l

install:
  #!/bin/bash
  export NIXPKGS_ALLOW_UNFREE=1
  nix profile add .#install

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
  install $(pwd)/config/wezterm $HOME/.config/wezterm
  install $(pwd)/config/zsh $HOME/.config/zsh
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
