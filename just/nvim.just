# Neovim: dependencias externas y plugins.
# El binario `nvim` lo aporta Nix (nix/packages.nix) y su configuración vive en
# config/nvim (symlink a ~/.config/nvim). Estas recetas solo se ocupan de lo que
# no puede vivir en el store de Nix: el compilador de gramáticas de tree-sitter
# (instalado con npm global) y los plugins que lazy.nvim descarga en ~/.local/share/nvim.

# Instala las dependencias externas que Neovim necesita (idempotente)
[group('Neovim')]
nvim-install:
  #!/usr/bin/env bash
  set -euo pipefail

  # npm llega desde el perfil de Nix: sin él no hay nada que instalar.
  if ! command -v npm >/dev/null 2>&1; then
    echo "Error: npm no está en el PATH. Ejecuta 'just nix-switch' primero." >&2
    exit 1
  fi

  # Compilador de gramáticas de tree-sitter, usado por nvim-treesitter para
  # generar parsers. npm reinstala sin quejarse si ya está presente.
  echo "Instalando tree-sitter-cli..."
  npm -g install tree-sitter-cli

# Actualiza tree-sitter-cli y los plugins de lazy.nvim
[group('Neovim')]
nvim-upgrade: nvim-install
  #!/usr/bin/env bash
  set -euo pipefail

  # @latest fuerza la resolución al último publicado: 'npm -g install <pkg>' a
  # secas no reinstala si ya hay una versión cualquiera en el perfil global.
  echo "Actualizando tree-sitter-cli..."
  npm -g install tree-sitter-cli@latest

  if ! command -v nvim >/dev/null 2>&1; then
    echo "Error: nvim no está en el PATH. Ejecuta 'just nix-switch' primero." >&2
    exit 1
  fi

  # Lazy! (con bang) hace la actualización síncrona; sin él el headless saldría
  # antes de que terminen las descargas.
  echo "Actualizando plugins de lazy.nvim..."
  nvim --headless +Lazy! update +qa
