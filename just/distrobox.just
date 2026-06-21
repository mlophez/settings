# Orchestrate full distrobox provisioning: create + install + config
[group('Distrobox')]
distrobox-setup: distrobox-init distrobox-install distrobox-config

alias dx-setup   := distrobox-setup
alias dx-init    := distrobox-init
alias dx-install := distrobox-install
alias dx-upgrade := distrobox-upgrade
alias dx-config  := distrobox-config

# Create the archlinux distrobox container
[group('Distrobox')]
distrobox-init:
  #!/usr/bin/env bash
  set -euo pipefail

  if [[ -f /run/.containerenv ]] || [[ -f /.dockerenv ]] || [[ -n "${CONTAINER_ID:-}" ]] || [[ -n "${DISTROBOX_ENTER_PATH:-}" ]]; then
    echo "Error: distrobox-init debe ejecutarse desde el host, no dentro de un contenedor." >&2
    exit 1
  fi

  # Persistent single-user nix store: bind-mount /nix to a host dir under $HOME
  mkdir -p "$HOME/.local/share/nix"

  distrobox rm archlinux -f || true
  distrobox-create --nvidia -Y -n archlinux --image {{distrobox_image}} --volume "$HOME/.local/share/nix:/nix:rw"
  distrobox enter archlinux -- sudo pacman --needed --noconfirm -S just

# Install or reinstall all software inside the existing container
[group('Distrobox')]
distrobox-install:
  #!/usr/bin/env bash
  set -euo pipefail

  if [[ ! -f /run/.containerenv ]] && [[ -z "${CONTAINER_ID:-}" ]] && [[ -z "${DISTROBOX_ENTER_PATH:-}" ]]; then
    echo "Ejecutando distrobox-install dentro del contenedor archlinux..."
    exec distrobox enter archlinux -- just distrobox-install
  fi

  sudo pacman-key --init
  sudo pacman -Syu --noconfirm
  # sudo pacman --needed --noconfirm -S wezterm code
  sudo pacman --needed --noconfirm -S $(cat $(pwd)/images/archlinux/archlinux.lst | grep -v "^ *#" | tr '\n' ' ')

  # Install nix inside the container (single-user, idempotent)
  if command -v nix >/dev/null 2>&1; then
    echo "nix ya está instalado en archlinux; omitiendo bootstrap."
  else
    sh <(curl -L https://nixos.org/nix/install) --no-daemon
  fi

# Upgrade the packages inside the container
[group('Distrobox')]
distrobox-upgrade:
  #!/usr/bin/env bash
  distrobox enter archlinux -- sudo pacman -Syu --noconfirm

[group('Distrobox')]
distrobox-config:
  #!/usr/bin/env bash
  set -euo pipefail

  if [[ ! -f /run/.containerenv ]] && [[ -z "${CONTAINER_ID:-}" ]] && [[ -z "${DISTROBOX_ENTER_PATH:-}" ]]; then
    echo "Ejecutando distrobox-config dentro del contenedor archlinux..."
    exec distrobox enter archlinux -- just distrobox-config
  fi

  sudo ln -sf /usr/sbin/distrobox-host-exec /usr/bin/distrobox
  sudo ln -sf /usr/sbin/distrobox-host-exec /usr/bin/podman
  sudo ln -sf /usr/sbin/distrobox-host-exec /usr/bin/flatpak
  sudo ln -sf /usr/sbin/distrobox-host-exec /usr/bin/gsettings
  sudo ln -sf /usr/sbin/distrobox-host-exec /usr/bin/ujust
  sudo ln -sf /usr/sbin/distrobox-host-exec /usr/bin/bootc

  #distrobox-export --app wezterm
  #distrobox-export --bin /usr/bin/wezterm --export-path $HOME/.local/bin
  #distrobox-export --app code

[private]
[group('Distrobox')]
distrobox-autostart:
  #!/bin/bash
  mkdir -p $HOME/.config/autostart/
  cat << EOF > $HOME/.config/autostart/archlinux.desktop
  [Desktop Entry]
  Name=Archlinux
  Comment=Archlinux Distrobox
  Exec=/bin/bash -c 'distrobox enter archlinux -- echo'
  Type=Application
  EOF

[private]
[group('Distrobox')]
dx-host-alias:
  sudo ln -sf /usr/sbin/distrobox-host-exec /usr/bin/distrobox
  sudo ln -sf /usr/sbin/distrobox-host-exec /usr/bin/podman
  sudo ln -sf /usr/sbin/distrobox-host-exec /usr/bin/flatpak
  sudo ln -sf /usr/sbin/distrobox-host-exec /usr/bin/gsettings
  sudo ln -sf /usr/sbin/distrobox-host-exec /usr/bin/dconf
  sudo ln -sf /usr/sbin/distrobox-host-exec /usr/bin/rofi

[private]
[group('Distrobox')]
dx-export:
  type alacritty &>/dev/null && distrobox-export --bin /usr/bin/alacritty --export-path $HOME/.local/bin
  type kitty &>/dev/null && distrobox-export --bin /usr/bin/kitty --export-path $HOME/.local/bin
  type code &>/dev/null && distrobox-export --app code
