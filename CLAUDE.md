# WORKSTATION

## Purpose

Versioned dotfiles and configuration repository for Miguel's workstation (Linux and macOS).
This is not application code: it consists of configuration files + a `just` orchestrator + Nix Home Manager to manage packages and symlinks into the user's `$HOME`.

The Containerfile is used to build the OS distribution by deriving from Universal Blue, which is based on Fedora Atomic Desktop.

Three versioned hierarchies, all mapped onto the system via symlinks:
- `config/` → user dotfiles and application configuration. Each subfolder is symlinked to its destination under `$HOME` (typically `~/.config/<app>`, see the `dotfiles` recipe in the `Justfile`).
- `default/` → system-level configuration (`/etc/`). Each file/subfolder is symlinked to its equivalent path under `/etc/` (requires `sudo`).
- `bin/` → user executable scripts. Each file is symlinked to `$HOME/.local/bin/<script>`.

The full repo tree is also symlinked at `$HOME/.local/share/settings`.

## Main commands

Single entry point: `just` from the repo root.
Run `just` to see the help.

## Architecture

### Platform and environments

- macOS: Homebrew for GUI apps (see README), Nix Home Manager for CLI tools.
- Linux: Flatpak for GUI apps (`linux-setup-apps`), Distrobox `archlinux` for tools not available on the host (ublue/ostree), Nix optional. Apps from the distrobox are exported to the host with `distrobox-export`.
