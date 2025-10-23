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
    [[ -s $dest ]] && rm $dest
    echo $src - $dest
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
  install $(pwd)/config/aws $HOME/.aws
  install $(pwd)/config/ssh $HOME/.ssh

