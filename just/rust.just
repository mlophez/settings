# Toolchain de Rust, gestionado con rustup.
# El binario `rustup` lo aporta Nix (nix/packages.nix): estas recetas solo se
# ocupan del toolchain y de los componentes, que rustup descarga en ~/.rustup
# y por tanto no pueden vivir en el store de Nix.

# Componentes que se quieren siempre presentes en el toolchain por defecto.
# rust-analyzer se instala aquí y no desde nixpkgs: el shim de rustup ya ocupa
# bin/rust-analyzer y los dos juntos rompen el buildEnv del perfil.
rust_components := "rust-analyzer rustfmt clippy rust-src"

# Bootstrap del toolchain stable y de todos sus componentes (idempotente)
[group('Rust')]
rust-install:
  #!/usr/bin/env bash
  set -euo pipefail

  # rustup llega desde el perfil de Nix: sin él no hay nada que hacer.
  if ! command -v rustup >/dev/null 2>&1; then
    echo "Error: rustup no está en el PATH. Ejecuta 'just nix-switch' primero." >&2
    exit 1
  fi

  # Solo descarga el toolchain si aún no está; rustup no es barato en red.
  if rustup toolchain list | grep -q '^stable'; then
    echo "Toolchain stable ya instalado."
  else
    echo "Instalando toolchain stable..."
    rustup toolchain install stable --no-self-update
  fi

  # Se fija siempre, aunque el toolchain ya existiera: deja el default correcto
  # si venía apuntando a nightly o a un toolchain de un proyecto concreto.
  echo "Fijando stable como toolchain por defecto..."
  rustup default stable

  # rustup ignora en silencio los componentes que ya están presentes.
  echo "Instalando componentes: {{ rust_components }}"
  rustup component add {{ rust_components }}

# Actualiza el toolchain y sus componentes a la última stable
[group('Rust')]
rust-upgrade: rust-install
  #!/usr/bin/env bash
  set -euo pipefail

  # --no-self-update: el rustup del store de Nix es de solo lectura y no puede
  # actualizarse a sí mismo; eso lo hace 'just nix-upgrade'.
  echo "Actualizando toolchain stable..."
  rustup update stable --no-self-update
