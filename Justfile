platform := os()
image := "localhost/workstation" # solo usado por legacy/system.just (flujo bootc)
distrobox_image := "docker.io/library/archlinux:latest"
# distrobox_image := "quay.io/toolbx-images/archlinux-toolbox:latest"
# distrobox_image := "ghcr.io/ublue-os/arch-distrobox:latest"
chooser := "fzf --preview 'just --show {}'"

[private]
default:
    @just -u -l

[private]
ui:
    @just --choose --unsorted --chooser {{ quote(chooser) }}

# Punto de entrada único y multiplataforma para instalar los toolchains
# gestionados por este repo. Espejo de `just upgrade`: mismos canales, misma
# ampliación a medida que aparecen otros nuevos.
# Install all toolchains managed by this repo
[group('General')]
install:
  # nix-switch va primero: aporta npm y uv, de los que dependen los siguientes.
  @just nix-switch
  @just rust-install
  @just nvim-install
  @just pi-install
  @just claude-install
  @just devbox-install
  @just harlequin-install
  # Declarada por partida doble ([linux] y [macos]): en macOS es un no-op.
  @just flatpak-install
  # Declarada por partida doble ([macos] y [linux]): en Linux es un no-op.
  @just brew-install

# Punto de entrada único y multiplataforma para actualizar todo el software
# gestionado por este repo: se le añaden canales a medida que aparecen.
# Upgrade all software channels managed by this repo
[group('General')]
upgrade:
  @just nix-upgrade
  @just rust-upgrade
  @just nvim-upgrade
  @just pi-upgrade
  @just claude-upgrade
  @just devbox-upgrade
  @just harlequin-upgrade
  # Declarada por partida doble ([linux] y [macos]): en macOS es un no-op.
  @just flatpak-upgrade
  # Declarada por partida doble ([macos] y [linux]): en Linux es un no-op.
  @just brew-upgrade

# Punto de entrada único para la configuración del usuario: symlinks primero y
# después la configuración de aplicaciones que no se resuelve con un symlink.
# Apply the user configuration
[group('General')]
config:
  @just config-dotfiles
  @just vscode-extensions-install

# Punto de entrada único para los backups. Hoy solo hay un destino (el disco
# USB externo); se le añaden más a medida que aparezcan, igual que install/upgrade.
# Back up user files to every configured destination
[group('General')]
backup:
  @just backup-to-disk

# Punto de entrada único para liberar espacio en disco. De momento solo encadena
# las cachés; se le añaden otras recetas clean-* cuando toque.
# Free up disk space
[group('General')]
clean:
  @just clean-cache

import 'just/system.just'
import 'just/setup.just'
import 'just/nix.just'
import 'just/rust.just'
import 'just/nvim.just'
import 'just/pi.just'
import 'just/claude.just'
import 'just/devbox.just'
import 'just/kiro.just'
import 'just/harlequin.just'
import 'just/bitwarden.just'
import 'just/flutter.just'
import 'just/flatpak.just'
import 'just/brew.just'
import 'just/vscode.just'
import 'just/distrobox.just'
import 'just/settings.just'
import 'just/gnome.just'
import 'just/backup.just'
import 'just/clean.just'
