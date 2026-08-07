{ pkgs }:

# Paquetes exclusivos de la máquina Linux (Fedora).
# El tooling CLI común vive en ./packages.nix.

with pkgs; [
  # Solo existe para Linux en nixpkgs; macOS ya trae su propio traceroute.
  traceroute

  # Compilador C/C++ nativo de la plataforma: en Linux es gcc.
  # No puede ir en packages.nix porque colisiona con clang (bin/cc, bin/c++).
  gcc
]
