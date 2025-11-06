# Configure symlinks for config files
dotfiles:
  #!/bin/bash
  install () {
    local src=$1
    local dest=$2
    [[ -d $dest ]] && rm -r "$dest"
    [[ -f $dest ]] && rm "$dest"
    echo $src - $dest
    mkdir -p "$(dirname "$dest")"
    ln -sf "$src" "$dest"
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
  install $(pwd)/config/nvim $HOME/.config/nvim
  install $(pwd)/config/git $HOME/.config/git
  install $(pwd)/config/k9s $HOME/.config/k9s
  install $(pwd)/config/just $HOME/.config/just
  install $(pwd)/config/kube/config $HOME/.config/kube/config
  install $(pwd)/config/aws/config $HOME/.aws/config
  install $(pwd)/config/ssh/config $HOME/.ssh/config
  install $(pwd)/config/containers $HOME/.config/containers

[private]
dotfiles-macos:
  #!/usr/bin/env bash
  install $(pwd)/config/k9s "$HOME/Library/Application Support/k9s"
  # DOCKER, TODO: in linux only put docker, not podman
  install $(pwd)/local/bin/docker-wrapper.sh $HOME/.local/bin/docker
  install $(pwd)/local/bin/docker-wrapper.sh $HOME/.local/bin/podman

# Get Git Repositories
clone-repositories:
	#!/usr/bin/env bash
	mkdir -p $HOME/Code; cd $HOME/Code
	git clone https://github.com/MLR96/settings.git
	git clone https://github.com/MLR96/ldapproxy.git
	git clone https://github.com/MLR96/jwauto.git
	git clone https://github.com/MLR96/TimeManager.git


