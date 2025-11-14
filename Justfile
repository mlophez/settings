import "recipes/linux.just"
import "recipes/macos.just"
import "recipes/nix.just"
import "recipes/distrobox.just"
import "recipes/settings.just"
import "recipes/gnome.just"

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
