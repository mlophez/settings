import "just/linux.just"
import "just/macos.just"
import "just/nix.just"
import "just/distrobox.just"
import "just/settings.just"
import "just/gnome.just"

platform := os()

[private]
default:
  @just -u -l

# Run all
setup:
  @just {{platform}}-setup

# Upgrade all in terminal, packages nvim plugins etc.
upgrade:
  @just {{platform}}-upgrade-terminal
