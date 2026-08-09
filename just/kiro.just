# Kiro CLI. No hay subcomando de actualización documentado: el propio instalador
# detecta la instalación previa y la reemplaza, así que kiro-upgrade reejecuta el
# instalador (puede pedir confirmación interactiva).

# Instala Kiro CLI con el instalador oficial
[group('Kiro')]
kiro-install:
  curl -fsSL https://cli.kiro.dev/install | bash

# Reejecuta el instalador oficial para dejar Kiro CLI en la última versión
[group('Kiro')]
kiro-upgrade: kiro-install
