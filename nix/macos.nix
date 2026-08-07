{ pkgs }:

# Paquetes exclusivos de la máquina macOS.
# El tooling CLI común vive en ./packages.nix.

with pkgs; [
  # Automatización de builds iOS/Android: solo tiene sentido en el Mac.
  fastlane

  # Compilador C/C++ nativo de la plataforma: en macOS es clang.
  # No puede ir en packages.nix porque colisiona con gcc (bin/cc, bin/c++).
  clang
]
