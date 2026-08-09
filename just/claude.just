# Claude Code CLI. El instalador oficial gestiona su propio directorio bajo
# ~/.local; la actualización la hace el propio binario con 'claude update'.

# Instala Claude Code con el instalador oficial
[group('Claude')]
claude-install:
  curl -fsSL https://claude.ai/install.sh | bash

# Actualiza Claude Code a la última versión
[group('Claude')]
claude-upgrade:
  #!/usr/bin/env bash
  set -euo pipefail

  if ! command -v claude >/dev/null 2>&1; then
    echo "Error: claude no está en el PATH. Ejecuta 'just claude-install' primero." >&2
    exit 1
  fi

  claude update
