{ pkgs }:

# Lista de paquetes CLI compartida por Linux y macOS.
# Debe ser idéntica en las dos máquinas: los extras por plataforma viven en
# ./linux.nix y ./macos.nix.
#
# Las aplicaciones gráficas NO van aquí: se gestionan con Flatpak (Linux)
# y con Homebrew / App Store (macOS).

with pkgs; [
  # FONTS
  nerd-fonts.fira-code

  # NETWORK
  curl
  wget
  autossh
  sshpass
  wol
  inetutils
  dnsutils
  nmap
  mitmproxy
  httpie
  curlie
  ngrok

  # ZSH
  zsh
  zsh-completions
  zsh-autosuggestions
  zsh-syntax-highlighting
  starship

  # SHELL
  fish
  nushell

  # TOOLS
  fzf
  television
  expect
  bc
  jq
  yq
  tree
  eza
  lsd
  superfile # TUI file manager
  ranger # TUI file manager
  colordiff
  bat
  gnused
  dialog
  tmux
  zellij
  entr
  ripgrep
  fd
  xdg-ninja

  # FILES
  unrar
  unzip
  gnutar
  p7zip
  zip

  # EDITOR
  nano
  neovim

  # LINTERS
  prettier
  mdformat

  # SECURITY
  gnupg
  paperkey
  zbar
  pass
  passExtensions.pass-otp
  # cryfs: eliminado de nixpkgs (dependía de FUSE 2, ya retirado).
  # La alternativa sugerida es gocryptfs, pero NO lee volúmenes CryFS existentes.

  # BACKUPS
  borgbackup
  rsync
  rclone

  # UTILS
  htop
  btop
  man
  just

  ##################### DEVELOPMENT #####################
  # TOOLS
  devbox

  # PYTHON
  python3
  pyright
  mypy
  isort
  black
  ruff
  uv

  # GO
  go
  go-tools
  gopls
  delve

  # NODE
  nodejs
  yarn
  pnpm
  bun

  # TYPESCRIPT
  typescript

  # RUST
  rustup

  # LUA
  lua-language-server

  # JAVA
  maven
  jdk21

  # IA
  opencode

  ##################### DEV/OPS #####################
  # GIT
  git
  git-lfs
  delta
  lazygit

  # ANSIBLE
  ansible
  ansible-lint

  # TERRAFORM
  terraform
  terraform-ls
  terragrunt

  ## CONTAINERS
  skopeo

  # KUBERNETES
  kubectl
  kubecolor
  kustomize
  stern
  conftest
  kubernetes-helm # ojo: 'helm' a secas es un sintetizador, no el de Kubernetes
  kompose
  k9s
  trivy
  kubeseal

  # AWS
  awscli2
  ssm-session-manager-plugin
]
