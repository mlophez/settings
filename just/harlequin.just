# Harlequin (cliente SQL de terminal), instalado como herramienta aislada de uv:
# trae sus propios adaptadores de base de datos y no encaja en el perfil de Nix.
# Su configuración vive en config/harlequin (symlink hecho por config-dotfiles).

# Instala Harlequin como herramienta de uv (idempotente)
[group('Harlequin')]
harlequin-install:
  #!/usr/bin/env bash
  set -euo pipefail

  # uv llega desde el perfil de Nix: sin él no hay nada que instalar.
  if ! command -v uv >/dev/null 2>&1; then
    echo "Error: uv no está en el PATH. Ejecuta 'just nix-switch' primero." >&2
    exit 1
  fi

  uv tool install harlequin

# Actualiza Harlequin a la última versión publicada
[group('Harlequin')]
harlequin-upgrade: harlequin-install
  uv tool upgrade harlequin
