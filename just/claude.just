# Claude Code CLI. El instalador oficial gestiona su propio directorio bajo
# ~/.local; la actualización la hace el propio binario con 'claude update'.

# Instala Claude Code con el instalador oficial (idempotente)
[group('Claude')]
claude-install:
  #!/usr/bin/env bash
  set -euo pipefail

  # Guard de idempotencia: `just install` encadena esta receta, y sin él cada
  # pasada volvería a bajarse el instalador por red.
  if command -v claude >/dev/null 2>&1; then
    echo "Claude Code ya está instalado; usa 'just claude-upgrade' para actualizarlo."
    exit 0
  fi

  curl -fsSL https://claude.ai/install.sh | bash

# Actualiza Claude Code a la última versión
[group('Claude')]
claude-upgrade:
  #!/usr/bin/env bash
  set -euo pipefail

  # Se omite en lugar de fallar: esta receta va encadenada en `just upgrade` y
  # no toda máquina tiene Claude Code instalado.
  if ! command -v claude >/dev/null 2>&1; then
    echo "Claude Code no está instalado; omitiendo."
    exit 0
  fi

  claude update
