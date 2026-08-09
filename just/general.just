# Punto de entrada único y multiplataforma para instalar los toolchains
# gestionados por este repo. Espejo de `just upgrade`: mismos canales, misma
# ampliación a medida que aparecen otros nuevos.
# Install all toolchains managed by this repo
[group('General')]
install:
  @just nix-switch
  @just rust-install
  @just nvim-install

# Punto de entrada único y multiplataforma para actualizar todo el software
# gestionado por este repo: se le añaden canales a medida que aparecen.
# Upgrade all software channels managed by this repo
[group('General')]
upgrade:
  @just nix-upgrade
  @just rust-upgrade
  @just nvim-upgrade

# Punto de entrada único para la configuración del usuario. De momento solo
# encadena los symlinks; se le añaden otras recetas config-* cuando toque.
# Apply the user configuration
[group('General')]
config:
  @just config-dotfiles

# Punto de entrada único para los backups. Hoy solo hay un destino (el disco
# USB externo); se le añaden más a medida que aparezcan, igual que install/upgrade.
# Back up user files to every configured destination
[group('General')]
backup:
  @just backup-to-disk

# Punto de entrada único para liberar espacio en disco. De momento solo encadena
# las cachés; se le añaden otras recetas clean-* cuando toque.
# Free up disk space
[group('General')]
clean:
  @just clean-cache
