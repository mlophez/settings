[private]
linux-setup:
  # Setup gnome
  @just gnome-load-settings
  # Install gui apps
  @just linux-setup-apps
  # Install distroboxes
  @just distrobox-setup
  #@just nix-install
  # Configure dotfiles
  @just dotfiles

[private]
linux-setup-apps:
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
	flatpak install -y https://downloads.1password.com/linux/flatpak/1Password.flatpakref || /bin/true

	flatpak install flathub com.mattjakeman.ExtensionManager

	#flatpak --user override --filesystem=xdg-data/themes
	#flatpak --user override --filesystem=xdg-data/icons

[private]
linux-setup-fonts:
	#!/usr/bin/env bash
	mkdir -p $HOME/.local/share/fonts
	cd $HOME/.local/share/fonts
	wget -nc -q -O JetBrainsMono.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip
	wget -nc -q -O SourceCodePro.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/SourceCodePro.zip
	unzip -o SourceCodePro.zip '*.ttf'
	unzip -o JetBrainsMono.zip '*.ttf'
	fc-cache

[private]
linux-setup-android-development:
	#!/usr/bin/env bash
	export ANDROID_HOME="$HOME/.local/share/android"
	export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"
	mkdir -p $ANDROID_HOME/cmdline-tools/latest; cd $ANDROID_HOME
	wget -nc -q -O cmdline-tools.zip 'https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip'
	bsdtar xvf cmdline-tools.zip --strip-components=1 -C cmdline-tools/latest # unzip cmdline-tools.zip 'cmdline-tools/*' -d 'cmdline-tools/latest'
	sdkmanager --install "platform-tools"
	sdkmanager --install "platforms;android-33"
	# sdkmanager --install "cmdline-tools;latest"

[private]
linux-setup-flutter-development:
	#!/usr/bin/env bash
	mkdir -p $HOME/.local/share/flutter; cd $HOME/.local/share/flutter
	wget -nc -q -O flutter.tar.xz 'https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.3-stable.tar.xz'
	rm -rf flutter/ &>/dev/null
	tar -xvf flutter.tar.xz
	mv flutter default

[private]
linux-setup-gtk-themes:
	#!/usr/bin/env bash
	mkdir -p $HOME/.local/share/themes; cd $HOME/.local/share/themes
	wget -nc -q https://github.com/catppuccin/gtk/releases/download/v0.7.0/Catppuccin-Mocha-Standard-Peach-Dark.zip
	unzip -o Catppuccin-Mocha-Standard-Peach-Dark.zip

	# flatpak --user override --env=QT_QPA_PLATFORMTHEME=qt5ct
	# flatpak --user override --env=GTK_THEME=Catppuccin-Mocha-Standard-Peach-Dark:dark

	# mkdir -p "${HOME}/.config/gtk-4.0"
	# ln -sf "${HOME}/.local/share/themes/Catppuccin-Mocha-Standard-Peach-Dark/gtk-4.0/assets" "${HOME}/.config/gtk-4.0/assets"
	# ln -sf "${HOME}/.local/share/themes/Catppuccin-Mocha-Standard-Peach-Dark/gtk-4.0/gtk.css" "${HOME}/.config/gtk-4.0/gtk.css"
	# ln -sf "${HOME}/.local/share/themes/Catppuccin-Mocha-Standard-Peach-Dark/gtk-4.0/gtk-dark.css" "${HOME}/.config/gtk-4.0/gtk-dark.css"

[private]
vscode-setup-extensions:
	#!/usr/bin/env bash
	code --install-extension ms-python.python
	code --install-extension golang.go
	code --install-extension dart-code.flutter

	code --install-extension esbenp.prettier-vscode
	code --install-extension mhutchie.git-graph
	code --install-extension ritwickdey.liveserver
	code --install-extension christian-kohler.path-intellisense
	code --install-extension formulahendry.auto-rename-tag
	code --install-extension pranaygp.vscode-css-peek
	code --install-extension dbaeumer.vscode-eslint
	code --install-extension zignd.html-css-class-completion
	code --install-extension bradlc.vscode-tailwindcss
	code --install-extension dsznajder.es7-react-js-snippets
	code --install-extension gruntfuggly.bettercommen
	code --install-extension glenn2223.live-sass
	code --install-extension astro-build.astro-vscode

	code --install-extension catppuccin.catppuccin-vsc
	code --install-extension pkief.material-icon-theme

# Setup linux locale and user dirs
[private]
linux-settings-locale:
	#!/usr/bin/env bash
	mkdir -p $HOME/Desktop
	mkdir -p $HOME/Downloads
	mkdir -p $HOME/Templates
	mkdir -p $HOME/Public
	mkdir -p $HOME/Documents
	mkdir -p $HOME/Music
	mkdir -p $HOME/Pictures
	mkdir -p $HOME/Videos
	mkdir -p $HOME/.local/bin
	echo "en_US" > $HOME/.config/user-dirs.locale
	cat << EOF > $HOME/.config/user-dirs.dirs
	XDG_DESKTOP_DIR="\$HOME/Desktop"
	XDG_DOWNLOAD_DIR="\$HOME/Downloads"
	XDG_TEMPLATES_DIR="\$HOME/Templates"
	XDG_PUBLICSHARE_DIR="\$HOME/Public"
	XDG_DOCUMENTS_DIR="\$HOME/Documents"
	XDG_MUSIC_DIR="\$HOME/Music"
	XDG_PICTURES_DIR="\$HOME/Pictures"
	XDG_VIDEOS_DIR="\$HOME/Videos"
	EOF


