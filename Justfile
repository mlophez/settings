import "just/linux.just"
import "just/macos.just"
import "just/nix.just"
import "just/distrobox.just"
import "just/settings.just"
import "just/gnome.just"
import "just/backup.just"

platform := os()

[private]
default:
  @just -u -l

# Run all
setup:
  @just {{platform}}-setup
  npm -g install tree-sitter-cli
  # cargo install --locked tree-sitter-cli

# Upgrade all in terminal, packages nvim plugins etc.
upgrade:
  @just {{platform}}-upgrade-terminal
  npm -g install tree-sitter-cli

claude-install:
  curl -fsSL https://claude.ai/install.sh | bash

claude-setup:
  claude plugin marketplace add JuliusBrussee/caveman
  claude plugin install caveman@caveman

kiro-install:
  curl -fsSL https://cli.kiro.dev/install | bash
