# pi coding agent y su framework de orquestación multi-agente, instalados con
# npm global: no están en nixpkgs, así que no pueden vivir en el perfil de Nix.

# Instala pi-coding-agent y oh-my-pi (npm global, idempotente)
[group('Pi')]
pi-install:
  #!/usr/bin/env bash
  set -euo pipefail

  # npm llega desde el perfil de Nix: sin él no hay nada que instalar.
  if ! command -v npm >/dev/null 2>&1; then
    echo "Error: npm no está en el PATH. Ejecuta 'just nix-switch' primero." >&2
    exit 1
  fi

  echo "Instalando pi-coding-agent y oh-my-pi..."
  npm -g install @earendil-works/pi-coding-agent oh-my-pi

# Actualiza pi-coding-agent y oh-my-pi a la última versión publicada
[group('Pi')]
pi-upgrade: pi-install
  #!/usr/bin/env bash
  set -euo pipefail

  # @latest fuerza la resolución al último publicado: 'npm -g install <pkg>' a
  # secas no reinstala si ya hay una versión cualquiera en el perfil global.
  echo "Actualizando pi-coding-agent y oh-my-pi..."
  npm -g install @earendil-works/pi-coding-agent@latest oh-my-pi@latest
