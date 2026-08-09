# Aplicaciones gráficas del host Linux, gestionadas con Flatpak. En macOS el
# canal equivalente es Homebrew y estas recetas no aplican.

# Añade Flathub e instala todas las aplicaciones gráficas
[group('Flatpak')]
[linux]
flatpak-install:
	flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
	flatpak --user install -y flathub com.brave.Browser
	#flatpak --user install -y flathub com.google.Chrome
	#flatpak --user install -y flathub com.microsoft.Edge
	#flatpak --user install -y flathub org.chromium.Chromium
	#flatpak --user install -y flathub org.freedesktop.Platform.ffmpeg-full
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

	flatpak install flathub com.mattjakeman.ExtensionManager

	#flatpak --user override --filesystem=xdg-data/themes
	#flatpak --user override --filesystem=xdg-data/icons

# Actualiza todas las aplicaciones Flatpak instaladas
[group('Flatpak')]
[linux]
flatpak-upgrade:
  flatpak update -y
