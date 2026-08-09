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

  # Guard de idempotencia: `just install` encadena esta receta y uv no garantiza
  # un no-op cuando la herramienta ya está instalada.
  if command -v harlequin >/dev/null 2>&1; then
    echo "Harlequin ya está instalado; usa 'just harlequin-upgrade' para actualizarlo."
    exit 0
  fi

  uv tool install harlequin

# Actualiza Harlequin a la última versión publicada
[group('Harlequin')]
harlequin-upgrade:
  #!/usr/bin/env bash
  set -euo pipefail

  # Se omite en lugar de fallar: esta receta va encadenada en `just upgrade` y
  # no toda máquina tiene Harlequin instalado.
  if ! command -v uv >/dev/null 2>&1 || ! command -v harlequin >/dev/null 2>&1; then
    echo "Harlequin no está instalado; omitiendo."
    exit 0
  fi

  uv tool upgrade harlequin
