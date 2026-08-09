# WORKSTATION

## Description

Personal, versioned configuration repository for Miguel's workstation (Linux and macOS). It is not application
code: it holds user dotfiles, system configuration and a `just` orchestrator that rebuilds the whole environment
from scratch on a new machine. Configuration is mapped onto the system through idempotent symlinks, and
cross-platform CLI packages are managed with Nix Home Manager.

- **Linux (Fedora KDE Plasma, mutable):** Fedora KDE on Btrfs with Snapper snapshots, UEFI + systemd-boot and
  DNF5 package management. GUI apps via Flatpak, CLI tools via native DNF, the Arch distrobox and/or Nix Home
  Manager. Persistent data lives in `/srv`, separated from the system. See `docs/design.md` for the design and
  `docs/install.md` for the step-by-step installation.
- **macOS:** CLI packages via Nix Home Manager, GUI apps via Homebrew.
- **Both platforms:** every dotfile (`config/*`) and script (`bin/*`) is symlinked into the corresponding `$HOME`.

> The previous flow was based on an immutable bootc image derived from Bluefin/ublue. It is kept, unused, in
> `legacy/` (see `legacy/README.md`).

## Requirements

- `git`
- `just` (installed through Nix)
- Nix with flakes enabled — Determinate installer — plus `home-manager`
- `npm` (used for the global `tree-sitter-cli`)
- **Linux:** Fedora KDE Plasma, `dnf5`, `flatpak`, `podman`, `distrobox`
- **macOS:** Homebrew, Xcode Command Line Tools

## Setup

### Linux (Fedora KDE Plasma)

1. Install the base system. The from-scratch installation (Btrfs partitioning and subvolumes, systemd-boot,
   Snapper + DNF5) is documented step by step in **`docs/install.md`**; the design and its rationale in
   **`docs/design.md`**.

2. Clone this repository:

   ```bash
   mkdir -p ~/Code && cd ~/Code
   git clone <repo-url> Workstation
   cd Workstation
   ```

3. Set up the user environment:

   ```bash
   just config              # symlinks config/* and bin/* into $HOME + VS Code extensions (idempotent)
   just system-setup-linux  # bootstrap: flatpak apps + distrobox + dotfiles (+ GNOME, inert on KDE)
   just install             # every toolchain: Nix, Rust, Neovim, pi, Claude, Kiro, Devbox, Harlequin, Flatpak
   just distrobox-setup     # archlinux container for tools not available on the host
   just config-repositories # clones the work repositories into ~/Code
   ```

### macOS

1. Clone this repository:

   ```bash
   mkdir -p ~/Code && cd ~/Code
   git clone <repo-url> Workstation
   cd Workstation
   ```

2. Install Homebrew and the GUI applications:

   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

   brew install --cask container
   container system start

   brew tap FelixKratz/formulae
   brew install sketchybar

   brew install --cask spaceid raycast

   brew tap hashicorp/tap
   brew install hashicorp/tap/terraform
   ```

3. Install Nix (Determinate) and home-manager, then link the dotfiles:

   ```bash
   just install             # every toolchain: Nix, Rust, Neovim, pi, Claude, Kiro, Devbox, Harlequin
   just config              # symlinks config/* (plus the ~/Library/Application Support duplicates) + VS Code extensions
   ```

### Netskope (Logalty corporate environment)

The corporate CA has to be injected by hand into the Java truststore and into DBeaver:

```bash
security find-certificate -a -p /System/Library/Keychains/SystemRootCertificates.keychain > ~/system-ca.pem
security find-certificate -a -p /Library/Keychains/System.keychain >> ~/system-ca.pem

CACERTS="$(dirname $(readlink -f $(which java)))/../lib/security/cacerts"
cp $CACERTS ~/.local/share/certificates/netskope.jks
keytool -importcert \
  -trustcacerts \
  -alias netskope \
  -file ~/.local/share/certificates/netskope.ca.pem \
  -keystore ~/.local/share/certificates/netskope.jks \
  -storepass changeit

# DBeaver: add the JKS to /Applications/DBeaver.app/Contents/Eclipse/dbeaver.ini
#   -Djavax.net.ssl.trustStore=/Users/<user>/.local/share/certificates/netskope.jks
#   -Djavax.net.ssl.trustStorePassword=changeit
```

### Flutter / Android (optional)

```bash
xcode-select --install
sudo xcodebuild -license accept
```

On Linux: `just flutter-install`.

## Usage

Single entry point: `just` from the repository root. Run it without arguments to list every available recipe.

### Day-to-day (Linux)

- `just system-upgrade` — upgrades the host packages (`dnf5 upgrade`), wrapped by `bin/snapshot` in a pre/post
  pair of Snapper snapshots (see `docs/install.md`).
- `just system-install <pkg>...` — installs host packages (`dnf5 install`), also with snapshots.
- `just install` / `just upgrade` — every toolchain managed by this repo: Nix, Rust, Neovim, pi, Claude Code,
  Kiro, Devbox, Harlequin and the Flatpak applications.
- `just config` — recreates the `config/*` and `bin/*` symlinks and installs the VS Code extensions.
- `just clean` — clears caches to free disk space.

### Day-to-day (macOS)

- `just upgrade` — Nix, the Rust toolchain, the Neovim plugins and the CLI tools (pi, Claude Code, Kiro, Devbox,
  Harlequin). The Flatpak step skips itself on macOS.
- `just config` — recreates the symlinks and installs the VS Code extensions (skipped when `code` is absent).
- `just clean` — clears caches (browsers, Go, Poetry, Homebrew, Gradle, Podman, Terraform, Claude
  vm_bundles).
- `just nix-switch` / `just nix-upgrade` / `just nix-clean` — Home Manager management.

### Recipes by group

- **Distrobox:** `distrobox-setup` (`dx-setup`), `distrobox-init`, `distrobox-install`, `distrobox-upgrade`,
  `distrobox-config`.
- **Nix:** `nix-switch`, `nix-upgrade`, `nix-clean`, `nix-packages`.
- **Rust:** `rust-install`, `rust-upgrade`.
- **Neovim:** `nvim-install`, `nvim-upgrade`.
- **GNOME (previous setup; inert on KDE):** `gnome-load-config`, `gnome-save-config`, `gnome-load-keybinds`.
- **Backup:** `backup-to-disk`.
- **Clean:** `clean-cache`.
- **CLI tools (cross-platform):** `claude-install` / `claude-upgrade`, `kiro-install` / `kiro-upgrade`,
  `devbox-install` / `devbox-upgrade`, `harlequin-install` / `harlequin-upgrade`, `pi-install` / `pi-upgrade`.
- **VS Code:** `vscode-extensions-install`, `vscode-extensions-upgrade`.
- **Bitwarden:** `bitwarden-login`, `bitwarden-unlock`.
- **Linux only:** `flatpak-install` / `flatpak-upgrade`, `flutter-install` / `flutter-upgrade`.
- **Settings:** `config-claude`, `config-repositories`, `download-resources`.

## Development

- Build: not applicable.
- Test: not applicable, there is no test suite. Changes are verified manually on the target machine.
- Lint: `just --fmt --unstable --check`
- Format: `just --fmt --unstable`

Before committing, check that `just config` is still idempotent, and that the Home Manager configuration builds
when `flake.nix` or `nix/*.nix` were touched.

## Documentation

- [Agent and project reference](AGENTS.md) — architecture, code style, testing and security.
- [System design](docs/design.md) — Fedora / Btrfs / Snapper design and its rationale.
- [Installation](docs/install.md) — step-by-step installation of the base Linux system.
