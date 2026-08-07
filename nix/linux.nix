{ pkgs }:

# Paquetes exclusivos de la máquina Linux (Fedora).
# El tooling CLI común vive en ./packages.nix.

with pkgs; [
  # Solo existe para Linux en nixpkgs; macOS ya trae su propio traceroute.
  traceroute
]
