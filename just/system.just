# Package management for the mutable Fedora KDE host (DNF5).
# bin/snapshot (snapshots pre/post con Snapper) está aparcado: las operaciones
# de DNF se lanzan directas. Para snapshots manuales, ver system-snapshot.


# Paquetes base del host Fedora: control de versiones, orquestador, contenedores,
# canal de apps GUI (flatpak), canal CLI multiplataforma (nix, en los repos
# oficiales desde Fedora 44), snapshots del sistema (snapper) y terminal (ghostty,
# desde COPR).
base_packages := "git just podman podman-compose flatpak nix snapper ghostty"

# COPRs a habilitar antes de instalar: paquetes que no están en los repos oficiales.
# scottames/ghostty publica chroots de fedora-43/44/rawhide y va al día
# (pgdev/ghostty ya no existe en Copr).
coprs := "scottames/ghostty"

# Install host packages, e.g. `just system-install neovim ripgrep`
# Sin argumentos instala el conjunto base (base_packages), pensado para un host
# recién instalado. Primero habilita los COPR (idempotente) y después lanza el
# dnf5 normal, sin envolver en bin/snapshot (aparcado por ahora).
# Se llama system-install y no install por el mismo motivo que system-upgrade:
# `just install` es el agregador multiplataforma de general.just.
[group('System')]
[linux]
system-install *packages=base_packages:
  #!/usr/bin/env bash
  set -euo pipefail
  for copr in {{ coprs }}; do
    echo "Enabling COPR $copr"
    sudo dnf5 copr enable -y "$copr"
  done
  echo "Installing: {{ packages }}"
  sudo dnf5 install {{ packages }}
  # nix (paquete de Fedora): el uso single-user requiere pertenecer al grupo
  # nixbld. Guardado con getent para ser un no-op si nix no se instaló, y con
  # id -nG para ser idempotente. El grupo se aplica al reiniciar la sesión.
  if getent group nixbld >/dev/null && ! id -nG "$USER" | grep -qw nixbld; then
    echo "Adding $USER to nixbld group"
    sudo usermod -aG nixbld "$USER"
  fi

# Upgrade all host packages con un dnf5 normal, sin bin/snapshot (aparcado).
# Se llama system-upgrade y no upgrade: `just upgrade` es ahora el agregador
# multiplataforma de general.just.
[group('System')]
[linux]
system-upgrade:
  sudo dnf5 upgrade

# Create a manual snapper snapshot of the root subvolume, e.g. `just system-snapshot "antes de tocar X"`.
# Es un no-op (sale con 0) si snapper no está instalado o si / no es btrfs, para
# poder llamarla incondicionalmente desde otras recetas o en hosts sin snapshots.
[group('System')]
[linux]
system-snapshot description="manual snapshot":
  #!/usr/bin/env bash
  set -euo pipefail
  if ! command -v snapper >/dev/null 2>&1; then
    echo "[system-snapshot] snapper no está instalado; nada que hacer"
    exit 0
  fi
  # stat -f devuelve el tipo del sistema de ficheros que contiene /
  if [[ "$(stat -f -c %T /)" != "btrfs" ]]; then
    echo "[system-snapshot] / no es btrfs; nada que hacer"
    exit 0
  fi
  echo "[system-snapshot] creando snapshot: {{ description }}"
  sudo snapper -c root create --description "{{ description }}"

