# Devbox (Jetify). El instalador coloca un launcher más el binario CLI; la
# actualización oficial es 'devbox version update', que se encarga de ambos.

# Instala Devbox con el instalador oficial
[group('Devbox')]
devbox-install:
  curl -fsSL https://get.jetify.com/devbox | bash

# Actualiza el launcher y el binario de Devbox
[group('Devbox')]
devbox-upgrade:
  #!/usr/bin/env bash
  set -euo pipefail

  if ! command -v devbox >/dev/null 2>&1; then
    echo "Error: devbox no está en el PATH. Ejecuta 'just devbox-install' primero." >&2
    exit 1
  fi

  devbox version update
