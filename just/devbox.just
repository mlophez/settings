# Devbox (Jetify). El instalador coloca un launcher más el binario CLI; la
# actualización oficial es 'devbox version update', que se encarga de ambos.

# Instala Devbox con el instalador oficial (idempotente)
[group('Devbox')]
devbox-install:
  #!/usr/bin/env bash
  set -euo pipefail

  # Guard de idempotencia: `just install` encadena esta receta, y sin él cada
  # pasada volvería a bajarse el instalador por red.
  if command -v devbox >/dev/null 2>&1; then
    echo "Devbox ya está instalado; usa 'just devbox-upgrade' para actualizarlo."
    exit 0
  fi

  curl -fsSL https://get.jetify.com/devbox | bash

# Actualiza el launcher y el binario de Devbox
[group('Devbox')]
devbox-upgrade:
  #!/usr/bin/env bash
  set -euo pipefail

  # Se omite en lugar de fallar: esta receta va encadenada en `just upgrade` y
  # no toda máquina tiene Devbox instalado.
  if ! command -v devbox >/dev/null 2>&1; then
    echo "Devbox no está instalado; omitiendo."
    exit 0
  fi

  devbox version update
