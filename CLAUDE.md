# WORKSTATION

## Propósito

Repositorio de dotfiles y configuración versionada de la workstation (Linux y macOS) de Miguel.
No es código de aplicación: son ficheros de configuración + un orquestador en `just` + Nix Home Manager para gestionar paquetes y enlaces simbólicos al `$HOME` del usuario.

Tres jerarquías versionadas, todas mapeadas al sistema mediante symlinks:
- `config/` → dotfiles y configuración de aplicaciones del usuario. Cada subcarpeta se enlaza a su destino en `$HOME` (típicamente `~/.config/<app>`, ver receta `dotfiles` en `Justfile`).
- `default/` → configuración a nivel de sistema (`/etc/`). Cada fichero/subcarpeta se enlaza a su ruta equivalente bajo `/etc/` (requiere `sudo`).
- `bin/` → scripts ejecutables del usuario. Cada fichero se enlaza a `$HOME/.local/bin/<script>`.

El árbol completo del repo además se enlaza en `$HOME/.local/share/settings`.

## Comandos principales

Entrada única: `just` desde la raíz.
Ejecuta just para ver la ayuda

## Arquitectura

### Plataforma y entornos

- macOS: Homebrew para apps gráficas (ver README), Nix Home Manager para CLI.
- Linux: Flatpak para apps gráficas (`linux-setup-apps`), Distrobox `archlinux` para herramientas que no están en el host (ublue/ostree), Nix opcional. Las apps del distrobox se exportan al host con `distrobox-export`.

