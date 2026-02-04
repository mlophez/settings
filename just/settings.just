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
  # TERMINAL AND SHELL
  install $(pwd)/config/wezterm $HOME/.config/wezterm
  install $(pwd)/config/fish $HOME/.config/fish
  install $(pwd)/config/starship.toml $HOME/.config/starship.toml
  install $(pwd)/config/zellij $HOME/.config/zellij
  install $(pwd)/config/nvim $HOME/.config/nvim
  # OTHERS
  install $(pwd)/config/zsh $HOME/.config/zsh
  install $(pwd)/config/zsh/zshrc $HOME/.zshrc
  install $(pwd)/config/zsh/zshenv $HOME/.zshenv
  install $(pwd)/config/zsh/zprofile $HOME/.zprofile
  install $(pwd)/config/nix $HOME/.config/nix
  install $(pwd)/config/git $HOME/.config/git
  install $(pwd)/config/k9s $HOME/.config/k9s
  install $(pwd)/config/ngrok $HOME/.config/ngrok
  install $(pwd)/config/just $HOME/.config/just
  install $(pwd)/config/kube/config $HOME/.config/kube/config
  install $(pwd)/config/aws/config $HOME/.aws/config
  install $(pwd)/config/ssh/config $HOME/.ssh/config
  install $(pwd)/config/containers $HOME/.config/containers
  # install $(pwd)/local/bin/docker-wrapper.sh $HOME/.local/bin/docker
  # PLATFORM SPECIFIC
  if [[ "{{platform}}" == "macos" ]]; then
    install $(pwd)/config/k9s "$HOME/Library/Application Support/k9s"
    install $(pwd)/config/ngrok "$HOME/Library/Application Support/ngrok"
    ln -sf /opt/podman/bin/podman $HOME/.local/bin/docker
    # install $(pwd)/local/bin/docker-wrapper.sh $HOME/.local/bin/podman
  fi

# Get Git Repositories
clone-repositories:
  #!/usr/bin/env bash
  clone () {
    local repo=$1
    local path=$2
    [[ -d $path ]] && return
    git clone $repo $path
  }
  mkdir -p $HOME/Code; cd $HOME/Code
  clone https://github.com/MLR96/settings.git Workstation
  clone https://github.com/MLR96/ldapproxy.git LDAPProxy
  clone https://github.com/mlophez/chroniq.git Chroniq
  #clone https://mlophez@bitbucket.org/firmapro/sealed-secret-app.git SealedSecretsApp
  clone https://github.com/mlophez/turnix.git Zitania
  clone https://github.com/mlophez/kubeops-agent.git KubeOpsAgent


