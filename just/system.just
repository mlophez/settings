# Package management for the mutable Fedora KDE host (DNF5).
# Los snapshots pre/post los crea el script propio `bin/snapshot` (Snapper,
# subvolumen root), que envuelve la operación de DNF. Ver docs/install.md.

# Upgrade all host packages (dnf5), envuelto en snapshots pre/post de snapper.
# Se llama system-upgrade y no upgrade: `just upgrade` es ahora el agregador
# multiplataforma de general.just.
[group('System')]
[linux]
system-upgrade:
  bin/snapshot sudo dnf5 upgrade

# Install host packages con snapshots pre/post, e.g. `just install neovim ripgrep`
[group('System')]
[linux]
install *packages:
  bin/snapshot sudo dnf5 install {{packages}}
