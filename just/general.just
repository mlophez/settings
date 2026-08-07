# Run all
[group('General')]
install-all:
  @just system-setup-{{platform}}
  @just npm-global
  # cargo install --locked tree-sitter-cli

# Upgrade all in terminal, packages nvim plugins etc.
[group('General')]
upgrade-all:
  @just system-upgrade-terminal-{{platform}}
  @just npm-global

# Global npm CLI tools not available in nixpkgs
[group('General')]
npm-global:
  # tree-sitter grammars compiler used by Neovim
  npm -g install tree-sitter-cli
  # pi coding agent + its multi-agent orchestration framework
  npm -g install @earendil-works/pi-coding-agent oh-my-pi

# Clone reference config repos into resources/ (ignored by git)
[group('General')]
download-resources:
  #!/usr/bin/env bash
  clone () { local repo=$1; local path=$2; if [[ -d $path/.git ]]; then git -C "$path" pull --ff-only; else git clone "$repo" "$path"; fi; }
  mkdir -p $(pwd)/resources
  clone https://github.com/basecamp/omarchy.git $(pwd)/resources/omarchy

# Limpia cachés del sistema para liberar espacio en disco
[group('Clean')]
clean-cache:
  @echo "Limpiando cachés de navegadores..."
  rm -rf ~/Library/Caches/BraveSoftware
  rm -rf ~/Library/Caches/Firefox
  rm -rf ~/Library/Caches/Google
  @echo "Limpiando cachés de Go..."
  rm -rf ~/Library/Caches/go-build
  rm -rf ~/Library/Caches/goimports
  rm -rf ~/Library/Caches/gopls
  @echo "Limpiando caché de Poetry..."
  rm -rf ~/Library/Caches/pypoetry
  @echo "Limpiando Homebrew..."
  brew cleanup
  @echo "Limpiando cachés de Gradle..."
  rm -rf ~/.gradle/caches
  @echo "Limpiando Podman..."
  podman machine start || true
  podman system prune -a --volumes -f
  @echo "Limpiando VM de Claude Code..."
  rm -rf ~/Library/Application\ Support/Claude/vm_bundles
  @echo "Limpiando módulos de Go..."
  go clean -modcache
  @echo "Limpiando Terraform plugin cache..."
  rm -rf ~/.local/share/terraform/plugin-cache/*
  @echo "Listo."
