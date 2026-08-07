{ pkgs }:

# Paquetes exclusivos de la máquina macOS.
# El tooling CLI común vive en ./packages.nix.

with pkgs; [
  # Automatización de builds iOS/Android: solo tiene sentido en el Mac.
  fastlane
]
