# Aplicaciones gráficas del host Linux, gestionadas con Flatpak. En macOS el
# canal equivalente es Homebrew y estas recetas no aplican.
# Cada receta se declara dos veces, una por plataforma: `just` elige la que
# corresponde al sistema. La versión [macos] es un no-op a propósito, porque
# `just install` y `just upgrade` las encadenan en las dos plataformas y una
# receta [linux] a secas no existiría en macOS y rompería la cadena.

# Añade Flathub e instala todas las aplicaciones gráficas
[group('Flatpak')]
[linux]
flatpak-install:
  #!/usr/bin/env bash
  set -euo pipefail

  flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

  flatpak install -y flathub com.brave.Browser
  flatpak install -y flathub org.mozilla.firefox
  flatpak install -y flathub org.keepassxc.KeePassXC
  flatpak install -y flathub com.github.tchx84.Flatseal
  flatpak install -y flathub org.mozilla.Thunderbird
  flatpak install -y flathub com.calibre_ebook.calibre
  flatpak install -y flathub com.spotify.Client
  flatpak install -y flathub org.libreoffice.LibreOffice
  flatpak install -y flathub org.videolan.VLC
  flatpak install -y flathub org.gnome.Boxes
  flatpak install -y flathub com.usebottles.bottles
  flatpak install -y flathub org.telegram.desktop
  flatpak install -y flathub io.dbeaver.DBeaverCommunity
  flatpak install -y flathub com.ticktick.TickTick
  flatpak install -y flathub com.bitwarden.desktop
  flatpak install -y https://downloads.1password.com/linux/flatpak/1Password.flatpakref || /bin/true
  # -y como el resto: sin él la receta se queda esperando confirmación y bloquea
  # la cadena de `just install`.
  #flatpak install -y flathub com.mattjakeman.ExtensionManager

  #flatpak --user override --filesystem=xdg-data/themes
  #flatpak --user override --filesystem=xdg-data/icons

# Placeholder de macOS: aquí las apps gráficas se instalan con Homebrew
[group('Flatpak')]
[macos]
flatpak-install:
  @echo "Flatpak solo aplica en Linux; omitiendo."

# Actualiza todas las aplicaciones Flatpak instaladas
[group('Flatpak')]
[linux]
flatpak-upgrade:
  flatpak update -y

# Placeholder de macOS: aquí las apps gráficas las actualiza Homebrew
[group('Flatpak')]
[macos]
flatpak-upgrade:
  @echo "Flatpak solo aplica en Linux; omitiendo."
