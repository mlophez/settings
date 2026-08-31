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
  atuin # historial de shell con sincronización y búsqueda

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
  # Bundle de CAs de Mozilla: publica ~/.nix-profile/etc/ssl/certs/ca-bundle.crt
  # para que el tooling de nix (curl, git, python...) pueda verificar TLS fuera
  # de NixOS, donde no encuentra el trust store del sistema (p. ej. Fedora usa
  # /etc/pki/tls). En Fedora la shell exporta SSL_CERT_FILE hacia el bundle del
  # sistema; este queda disponible para usarlo a mano en hosts sin él.
  cacert
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

  # C/C++
  # El compilador en sí vive en ./linux.nix (gcc) y ./macos.nix (clang):
  # ambos aportan bin/cc y bin/c++ y colisionarían en el mismo perfil.
  cmake
  gnumake
  ninja
  pkg-config

  # PYTHON
  python3
  pyright
  mypy
  isort
  black
  pylint
  ruff
  uv

  # GO
  go
  go-tools
  gopls
  delve

  # NODE
  # nodejs_latest (26.x) en lugar del nodejs por defecto (24.x): el frontend de
  # platform exige Node >=26 en engines y su .npmrc pasa --no-webstorage, un
  # flag que no existe antes de Node 25.
  nodejs_latest
  yarn
  pnpm
  bun

  # TYPESCRIPT
  typescript

  # RUST
  rustup
  # rust-analyzer: no se añade aquí porque rustup ya publica su propio shim
  # bin/rust-analyzer y buildEnv falla por conflicto. Se instala con:
  #   rustup component add rust-analyzer

  # LUA
  lua-language-server

  # JAVA
  # Override: el maven de nixpkgs empaqueta un JDK 21 propio y lo usa cuando
  # JAVA_HOME no está definido, aunque el perfil tenga jdk25. Con el override
  # mvn arranca directamente sobre Java 25 sin exportar nada.
  (maven.override { jdk_headless = jdk25; })
  jdk25

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
  helmfile
  kompose
  eksctl
  k9s
  trivy
  kubeseal

  # AWS
  awscli2
  ssm-session-manager-plugin
]
