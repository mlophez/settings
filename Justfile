import "recipes/linux.just"
import "recipes/macos.just"
import "recipes/nix.just"
import "recipes/settings.just"
import "recipes/gnome.just"

platform := os()

[private]
default:
  @just -u -l

# Run all
setup:
  @echo {{platform}}-setup
