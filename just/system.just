# Package management for the mutable Fedora KDE host (DNF5).
# Snapshots pre/post NO se hacen aquí: los gestiona el plugin de acciones de
# libdnf5 (snapper) configurado a nivel de sistema. Ver docs/install.md.

# Upgrade all host packages (dnf5). Snapshots automáticos vía libdnf5-plugin-actions.
[group('System')]
[linux]
upgrade:
  sudo dnf5 upgrade

# Install host packages, e.g. `just install neovim ripgrep fd-find`
[group('System')]
[linux]
install *packages:
  sudo dnf5 install {{packages}}
