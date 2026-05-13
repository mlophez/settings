# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Propósito

Repositorio de dotfiles y configuración versionada de la workstation (Linux y macOS) de Miguel. No es código de aplicación: son ficheros de configuración + un orquestador en `just` + Nix Home Manager para gestionar paquetes y enlaces simbólicos al `$HOME` del usuario.

El árbol del repo se enlaza en `$HOME/.local/share/settings` y cada subcarpeta de `config/` se enlaza a su destino XDG (ver `just/settings.just`).

## Comandos principales

Entrada única: `just` desde la raíz. `Justfile` importa por plataforma y delega a `os()`.

- `just setup` — bootstrap completo de la plataforma actual (llama a `linux-setup` o `mac-setup`).
- `just upgrade` — actualiza terminal/paquetes según plataforma.
- `just dotfiles` — recrea todos los enlaces simbólicos de `config/*` a `$HOME` (idempotente: borra destino antes de re-enlazar).
- `just clone-repositories` — clona los repos auxiliares en `$HOME/Code`.
- `just nix-switch` — aplica la configuración Home Manager para la plataforma actual; `nix-upgrade` actualiza el flake y re-aplica; `nix-clean` recolecta basura.
- `just gnome-load-settings` — vuelca `gnome/settings.ini` y `gnome/keybindings.ini` con `dconf load` (solo Linux).
- `just distrobox-setup` — recrea el contenedor `archlinux` con los paquetes de `packages/archlinux.lst` (solo Linux).
- `just clean` — limpia cachés del sistema (solo macOS).

Sin tests, sin lint, sin build: cualquier validación es ejecutar el flujo correspondiente y observar el resultado en el sistema.

## Arquitectura

### Orquestación con `just`

`Justfile` raíz importa los módulos de `just/`:
- `just/linux.just`, `just/macos.just` — bootstraps específicos. La receta pública `setup` resuelve la plataforma con `os()` y delega.
- `just/settings.just` — `dotfiles` (linker simbólico, idempotente) y `clone-repositories`.
- `just/nix.just` — wrapper sobre `home-manager switch --flake .#{{platform}} --impure`.
- `just/distrobox.just`, `just/gnome.just`, `just/backup.just` — utilidades exclusivas de Linux.

Convención: recetas con `[private]` son detalles internos del bootstrap; las públicas son los puntos de entrada del usuario.

### Gestión de paquetes con Nix Home Manager

`flake.nix` expone dos `homeConfigurations`:
- `linux` → `x86_64-linux`, módulo `nix/linux.nix`, con overlay `nixGL` y `hyprland` pinneado.
- `macos` → `aarch64-darwin`, módulo `nix/macos.nix`.

Ambos módulos son listas planas de `home.packages`. Para añadir/quitar una herramienta CLI, edita el módulo de la plataforma correspondiente y aplica con `just nix-switch`. El flake usa `--impure` por necesidad de Home Manager con rutas absolutas del usuario.

### Dotfiles y symlinks

`just dotfiles` es la única fuente de verdad sobre dónde aterriza cada configuración. Lee esa receta antes de mover ficheros: el destino puede no ser el típico `~/.config/<app>` (ej. zsh enlaza `zshrc`/`zshenv`/`zprofile` directamente en `$HOME`; en macOS, k9s y ngrok se duplican en `~/Library/Application Support/`).

Reglas:
- Editar la configuración en `config/<app>/` del repo, nunca en el destino enlazado (los enlaces apuntan al repo, así que ambos lados son el mismo fichero, pero edita siempre desde aquí para que `git` lo vea).
- Si añades una app nueva, crea `config/<app>/` y añade la línea `install` a `just/settings.just`.

### Plataforma y entornos

- macOS: Homebrew para apps gráficas (ver README), Nix Home Manager para CLI.
- Linux: Flatpak para apps gráficas (`linux-setup-apps`), Distrobox `archlinux` para herramientas que no están en el host (ublue/ostree), Nix opcional. Las apps del distrobox se exportan al host con `distrobox-export`.

