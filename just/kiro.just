# Kiro CLI. No hay subcomando de actualización documentado: el propio instalador
# detecta la instalación previa y la reemplaza, así que kiro-upgrade lo reejecuta
# (puede pedir confirmación interactiva).

kiro_installer := "https://cli.kiro.dev/install"

# Instala Kiro CLI con el instalador oficial (idempotente)
[group('Kiro')]
kiro-install:
  #!/usr/bin/env bash
  set -euo pipefail

  # Guard de idempotencia: `just install` encadena esta receta, y sin él cada
  # pasada volvería a bajarse el instalador por red.
  if command -v kiro-cli >/dev/null 2>&1 || command -v kiro >/dev/null 2>&1; then
    echo "Kiro CLI ya está instalado; usa 'just kiro-upgrade' para actualizarlo."
    exit 0
  fi

  curl -fsSL {{ kiro_installer }} | bash

# Reejecuta el instalador oficial para dejar Kiro CLI en la última versión
[group('Kiro')]
kiro-upgrade:
  #!/usr/bin/env bash
  set -euo pipefail

  # Se omite en lugar de fallar: esta receta va encadenada en `just upgrade` y
  # no toda máquina tiene Kiro CLI instalado.
  if ! command -v kiro-cli >/dev/null 2>&1 && ! command -v kiro >/dev/null 2>&1; then
    echo "Kiro CLI no está instalado; omitiendo."
    exit 0
  fi

  curl -fsSL {{ kiro_installer }} | bash
