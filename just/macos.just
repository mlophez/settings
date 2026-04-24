[private]
mac-setup:
  @just nix-install

macos-upgrade-terminal: nix-upgrade

# Limpia cachés del sistema para liberar espacio en disco
clean:
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

[private]
netskope:
  mkdir -p $HOME/.local/share/certificates
  echo | openssl s_client -connect oidc.eu-west-1.amazonaws.com:443 -servername oidc.eu-west-1.amazonaws.com 2>/dev/null | openssl x509 -outform PEM > $HOME/.local/share/certificates/netskope.crt



