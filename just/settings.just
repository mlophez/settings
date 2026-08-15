# Único sitio donde se declaran los symlinks de config/* y bin/* hacia $HOME.
# El punto de entrada de diario es `just config` (general.just), que la encadena.
# Configure symlinks for config files
[group('Settings')]
config-dotfiles:
  #!/bin/bash
  link () { echo $1 - $2; mkdir -p "$(dirname "$2")"; ln -sfn "$1" "$2"; }
  unlink () { [[ -L "$2" ]] && rm "$2"; }
  # DoIt
  link $(pwd) $HOME/.local/share/settings
  # DESKTOP
  link $(pwd)/config/uwsm $HOME/.config/uwsm
  link $(pwd)/config/hypr $HOME/.config/hypr
  link $(pwd)/config/hypr/hyprcmd $HOME/.local/bin/hyprcmd
  link $(pwd)/config/hypr/hyprcmd $HOME/.local/bin/deskcmd
  link $(pwd)/config/waybar $HOME/.config/waybar
  # TERMINAL AND SHELL
  link $(pwd)/config/wezterm $HOME/.config/wezterm
  link $(pwd)/config/ghostty $HOME/.config/ghostty
  link $(pwd)/config/fish $HOME/.config/fish
  link $(pwd)/config/starship.toml $HOME/.config/starship.toml
  link $(pwd)/config/zellij $HOME/.config/zellij
  link $(pwd)/config/television $HOME/.config/television
  link $(pwd)/config/atuin $HOME/.config/atuin
  link $(pwd)/config/nvim $HOME/.config/nvim
  # ZSH
  link $(pwd)/config/zsh $HOME/.config/zsh
  unlink $(pwd)/config/zsh/zshrc $HOME/.zshrc
  unlink $(pwd)/config/zsh/zshenv $HOME/.zshenv
  unlink $(pwd)/config/zsh/zprofile $HOME/.zprofile
  # FLATPAK
  link $(pwd)/config/flatpak/overrides/global $HOME/.local/share/flatpak/overrides/global
  # OTHERS
  link $(pwd)/config/rofi $HOME/.config/rofi
  link $(pwd)/config/nix $HOME/.config/nix
  link $(pwd)/config/git $HOME/.config/git
  link $(pwd)/config/k9s $HOME/.config/k9s
  link $(pwd)/config/lazygit $HOME/.config/lazygit
  link $(pwd)/config/ngrok $HOME/.config/ngrok
  link $(pwd)/config/harlequin $HOME/.config/harlequin
  link $(pwd)/config/just $HOME/.config/just
  link $(pwd)/config/kube/config $HOME/.config/kube/config
  link $(pwd)/config/aws/config $HOME/.aws/config
  link $(pwd)/config/ssh/config $HOME/.ssh/config
  link $(pwd)/config/containers $HOME/.config/containers
  # install $(pwd)/local/bin/docker-wrapper.sh $HOME/.local/bin/docker
  # CLAUDE
  link $(pwd)/config/claude/CLAUDE.md $HOME/.claude/CLAUDE.md
  link $(pwd)/config/claude/skills $HOME/.claude/skills
  link $(pwd)/config/claude/commands $HOME/.claude/commands
  link $(pwd)/config/claude/agents $HOME/.claude/agents
  link $(pwd)/config/claude/references $HOME/.claude/references
  link $(pwd)/config/claude/settings.json $HOME/.claude/settings.json
  link $(pwd)/config/claude/statusline.sh $HOME/.claude/statusline.sh
  # OPENCODE
  link $(pwd)/config/opencode $HOME/.config/opencode
  # PLATFORM SPECIFIC
  if [[ "{{platform}}" == "macos" ]]; then
    link $(pwd)/config/k9s "$HOME/Library/Application Support/k9s"
    link $(pwd)/config/lazygit "$HOME/Library/Application Support/lazygit"
    link $(pwd)/config/ngrok "$HOME/Library/Application Support/ngrok"
    link $(pwd)/config/harlequin "$HOME/Library/Application Support/harlequin"
    link /opt/podman/bin/podman $HOME/.local/bin/docker
  fi

# Get Git Repositories
[group('Settings')]
config-repositories:
  #!/usr/bin/env bash
  clone () { local repo=$1; local path=$2; [[ -d $path ]] && return; git clone $repo $path; }
  mkdir -p $HOME/Code; cd $HOME/Code

  clone https://github.com/MLR96/settings.git Workstation

  # Zextime
  clone https://github.com/mlophez/zextime-app.git zextime-app
  clone https://github.com/mlophez/zextime-site.git zextime-site
  clone https://github.com/mlophez/zextime-webapp.git zextime-webapp

  # Tools
  clone https://mlophez@bitbucket.org/firmapro/herocd.git HeroCD
  clone https://mlophez@bitbucket.org/firmapro/sealed-secret-app.git sealed-secret-app

  # Logalty
  clone https://bitbucket.org/firmapro/terraform.git logalty-terraform
  clone https://bitbucket.org/firmapro/kubernetes.git logalty-kubernetes
  clone https://bitbucket.org/firmapro/tasks.git logalty-tasks
  clone https://bitbucket.org/firmapro/blog.git logalty-infra-blog
  clone https://bitbucket.org/firmapro/configcontroller.git logalty-eks-config-controller
  clone https://bitbucket.org/firmapro/docker.git logalty-image-repository

  #clone https://github.com/MLR96/ldapproxy.git LDAPProxy
  #clone https://mlophez@bitbucket.org/firmapro/sealed-secret-app.git SealedSecretsApp
  #clone https://github.com/mlophez/turnix.git Zitania
  #clone https://github.com/mlophez/kubeops-agent.git KubeOpsAgent

# Configure marketplace in claude code
[group('Settings')]
config-claude:
  claude plugin marketplace add JuliusBrussee/caveman
  claude plugin install caveman@caveman

# Clone reference config repos into resources/ (ignored by git)
[group('Settings')]
download-resources:
  #!/usr/bin/env bash
  clone () { local repo=$1; local path=$2; if [[ -d $path/.git ]]; then git -C "$path" pull --ff-only; else git clone "$repo" "$path"; fi; }
  mkdir -p $(pwd)/resources
  clone https://github.com/basecamp/omarchy.git $(pwd)/resources/omarchy
