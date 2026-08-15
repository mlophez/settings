# Aplicaciones gráficas del host macOS, gestionadas con Homebrew. En Linux el
# canal equivalente es Flatpak y estas recetas no aplican.
# Cada receta se declara dos veces, una por plataforma: `just` elige la que
# corresponde al sistema. La versión [linux] es un no-op a propósito, porque
# `just install` y `just upgrade` las encadenan en las dos plataformas y una
# receta [macos] a secas no existiría en Linux y rompería la cadena.

# Instala todas las aplicaciones gráficas gestionadas con Homebrew
[group('Brew')]
[macos]
brew-install:
  #!/usr/bin/env bash
  set -euo pipefail

  echo "Installing Homebrew casks..."
  brew install --cask ghostty

# Placeholder de Linux: aquí las apps gráficas se instalan con Flatpak
[group('Brew')]
[linux]
brew-install:
  @echo "Homebrew solo aplica en macOS; omitiendo."

# Actualiza todas las aplicaciones instaladas con Homebrew
[group('Brew')]
[macos]
brew-upgrade:
  #!/usr/bin/env bash
  set -euo pipefail

  echo "Upgrading Homebrew packages..."
  brew update
  brew upgrade

# Placeholder de Linux: aquí las apps gráficas las actualiza Flatpak
[group('Brew')]
[linux]
brew-upgrade:
  @echo "Homebrew solo aplica en macOS; omitiendo."
