# SDK de Flutter, instalado desde el tarball oficial en
# ~/.local/share/flutter/default. No vive en Nix: flutter escribe dentro de su
# propio árbol (artefactos del engine, parsers) y necesita ser mutable.
# Solo Linux: el índice de releases que se consulta es el de esa plataforma.

flutter_home := "$HOME/.local/share/flutter"

# Descarga el SDK stable si aún no está presente
[group('Flutter')]
[linux]
flutter-install:
  #!/usr/bin/env bash
  set -euo pipefail

  # Guard de idempotencia: si ya está el SDK, no se toca la red.
  if [[ -d "{{ flutter_home }}/default" ]]; then
    echo "Flutter ya está instalado en {{ flutter_home }}/default."
    exit 0
  fi

  just flutter-download

# Reemplaza el SDK por la última stable publicada
[group('Flutter')]
[linux]
flutter-upgrade: flutter-download

# Descarga y extrae el tarball de la última stable, sustituyendo lo que hubiera
[private]
[group('Flutter')]
[linux]
flutter-download:
  #!/usr/bin/env bash
  set -euo pipefail

  mkdir -p "{{ flutter_home }}"
  cd "{{ flutter_home }}"

  # El índice de releases publica el hash de la stable actual; de ahí sale el
  # nombre del archivo que hay que descargar.
  curl -fsSL 'https://storage.googleapis.com/flutter_infra_release/releases/releases_linux.json' \
    -o releases_linux.json
  hash=$(jq -r '.current_release.stable' releases_linux.json)
  version=$(jq -r ".releases[] | select(.hash == \"$hash\") | .archive" releases_linux.json)

  echo "Descargando Flutter stable ($hash)..."
  curl -fsSL -o flutter.tar.xz "https://storage.googleapis.com/flutter_infra_release/releases/$version"

  # El tarball extrae un directorio 'flutter/'; se renombra a 'default' para
  # dejar sitio a futuras versiones paralelas en el mismo árbol.
  rm -rf flutter default
  tar -xf flutter.tar.xz
  mv flutter default

  rm -f flutter.tar.xz releases_linux.json
