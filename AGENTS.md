# AGENTS.md

## Purpose

Personal, versioned configuration repository for Miguel's workstation (Linux and macOS). It is not application
code: it holds user dotfiles, system configuration and a `just` orchestrator that rebuilds the whole environment
from scratch. Configuration is mapped onto the machine through idempotent symlinks; CLI packages are managed with
Nix Home Manager.

## Stack

- `just` — orchestrator, single entry point for every reproducible action
- Bash — recipe bodies and executable scripts in `bin/`
- Nix flakes + Home Manager — `flake.nix`, `nix/linux.nix`, `nix/macos.nix`
- Lua — Neovim configuration (`config/nvim`)
- Fish and Zsh — shell configuration
- TOML / YAML / JSON — third-party application configuration under `config/`
- Linux host: Fedora KDE Plasma, DNF5, Flatpak, Podman, Distrobox (Arch)
- macOS host: Homebrew (GUI apps), Nix (CLI tools)

## Commands

- Build: not applicable
- Run: `just` (lists every recipe), `just <recipe>` to execute one
- Test: not applicable, there is no test suite
- Single test: not applicable
- Lint: `just --fmt --unstable --check`
- Format: `just --fmt --unstable`

No agent hooks are installed in this repository.

## Architecture

### Project layout

- `config/` — user dotfiles, one subfolder per application, symlinked into `$HOME` / `~/.config/<app>`
- `bin/` — user executable scripts, symlinked into `$HOME/.local/bin/<script>`
- `default/` — system configuration, replicating the `/etc/` path (convention; the folder does not exist yet)
- `Justfile` — root orchestrator, only variables and imports
- `just/` — recipes split by section: `general`, `system`, `apps`, `setup`, `nix`, `distrobox`, `settings`,
  `gnome`, `backup`
- `flake.nix` + `nix/` — Home Manager configuration, one entry point per platform
- `docs/` — `design.md` (Fedora/Btrfs/Snapper system design) and `install.md` (step-by-step installation)
- `share/` — installable assets (backgrounds, cursors)
- `images/` — Containerfiles for the distrobox and legacy OS images
- `legacy/` — previous bootc/ublue flow, frozen, not imported by the root `Justfile`
- `resources/` — reference config repos cloned by `download-resources`, gitignored

The whole repo tree is also symlinked at `$HOME/.local/share/settings`.

### Components

- Recipes (`just/*.just`) are the only entry point: every reproducible action is a recipe.
- `config/` and `bin/` are pure data: they are never executed from the repo, always through their symlink.
- `just/settings.just` owns the `config-dotfiles` recipe, the single place where symlinks are declared;
  `just config` (in `just/general.just`) is the entry point that chains it.
- `just/system.just` and `just/setup.just` own host-level actions (DNF5, fonts, locale, cursors) and are the only
  ones allowed to require `sudo`.
- `nix/*.nix` owns cross-platform CLI packages; recipes never install a CLI tool directly.
- `legacy/` is not imported by the root `Justfile` and must not be reintroduced into it.

### External integrations

- Package managers: DNF5 (Fedora host), Flatpak (Linux GUI apps), Homebrew (macOS GUI apps), Nix / nixpkgs
  (cross-platform CLI), pacman inside the Arch distrobox, global `npm` (`tree-sitter-cli`).
- Snapper and systemd-boot: `bin/snapshot` wraps `dnf5` operations in a pre/post snapshot pair so any host change
  is revertible from the boot menu.

### Configuration & environments

- There are no local/pre/pro environments. The only dimension is the platform.
- The `Justfile` resolves it with `platform := os()` and dispatches to `system-setup-{{platform}}` /
  `system-upgrade-terminal-{{platform}}`.
- The flake exposes `homeConfigurations."linux"` (x86_64-linux) and `homeConfigurations."macos"` (aarch64-darwin).
- Secrets are never part of the configuration: only the files that reference them by path are versioned.

## Code style

### Naming

No enforced naming convention. Follow the naming already used by the surrounding folder or recipe file.

### File organization

- New user application: create `config/<app>/` and add its `link` line to the `config-dotfiles` recipe in
  `just/settings.just`.
- New script: place it in `bin/`, `chmod +x`, and link it from the `config-dotfiles` recipe.
- New system configuration: place it under `default/`, replicating its `/etc/` path.
- New recipe: add it to the matching `just/<section>.just`; if the file is new, import it from the root `Justfile`.

### Error handling & logging

- Multi-line recipes and every script in `bin/` start with `#!/usr/bin/env bash` and `set -euo pipefail`.
- Log the action in progress with `echo` before running it.
- Operations must be idempotent: `ln -sfn`, `mkdir -p`, and early guards such as `[[ -d $path ]] && return`.

### Dependencies

Pick the channel by the nature of the dependency:

- Cross-platform CLI tool: add it to `nix/linux.nix` or `nix/macos.nix`, then `just nix-switch`.
- GUI application: Flatpak on Linux (`just/apps.just`), Homebrew on macOS.
- Fedora host package: `just system-install <pkg>` (DNF5, wrapped in pre/post snapshots).
- Not available on the host: install it inside the Arch distrobox and expose it with `distrobox-export`.

### Git workflow

- Work directly on `main`; no feature branches, no pull requests.
- Small commits, one-line messages in English.

### Forbidden patterns

- Hardcoded absolute paths (`/Users/miguel.lopez`, `/home/mlr`) in versioned files: use `$HOME`, `$(pwd)` or the
  `platform` variable.
- Installation steps living only in the README: every reproducible step belongs to a recipe.
- Secrets in the repo: no keys, tokens, `auth.json` or kubeconfigs with credentials. Add them to `.gitignore`.

## Testing

### Strategy

There is no test suite and no test framework. Changes are verified manually on the target machine.

### Running tests

Not applicable. The available checks are:

- `just --fmt --unstable --check` — recipe formatting
- `just config` — must be idempotent and leave every symlink intact
- `nix flake check` / `home-manager build` — when `flake.nix` or `nix/*.nix` changed

### Writing tests

Not applicable.

### Acceptance criteria

`just --fmt --unstable --check` passes, `just config` runs idempotently without breaking symlinks, and the Home
Manager configuration still builds when `nix/` was touched.

## Security

### Secrets & credentials

- Private keys and certificates (`id_*`, `*.pem`, `*.key`, `*.p12`, `*.jks`) are secrets and are never committed.
- Only the configuration that references them by path is versioned (`config/ssh/config`, `config/gnupg/`).
- Already gitignored and to be kept that way: `config/containers/auth.json`,
  `config/containers/podman-connections.json*`, `config/k9s/clusters`, `resources/`.
- `config/aws/config` and `config/kube/config` hold profiles and endpoints only, never credentials.

### Input validation & sensitive data

The repository is public on GitHub. Never commit internal hostnames, private IPs, customer names or Logalty
infrastructure URLs.

### Dependency audit

Manual, periodic updates. There is no CVE audit tooling.

- `just nix-upgrade` — updates `flake.lock` and applies the new generation
- `just upgrade` — Nix profile, Rust toolchain and Neovim (tree-sitter-cli + lazy.nvim plugins)

## Project notes

- Symlinks are live: editing `config/<app>` changes the running configuration of the machine immediately. There is
  no deploy step, so a broken file breaks the real application.
- On macOS several applications are additionally linked into `~/Library/Application Support/`: add the extra line
  to the platform-specific block of the `config-dotfiles` recipe.
- Always pass the profile/context explicitly: `aws --profile <profile>` and `kubectl --context <context>`. Ignore
  the global `AWS_PROFILE`.
- In the Logalty corporate environment the Netskope CA must be injected by hand into the Java truststore and into
  DBeaver (procedure in the README).

## Architecture decisions

### How write just recipes

- Must be idempotent, multiple execution must be output same changes or not changes if already done.
- The recepies in General section always point to other recipies.
