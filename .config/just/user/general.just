# vim: ft=make

dotfiles:
	#!/usr/bin/env bash
	set -euxo pipefail
	alias dot="git --git-dir=$HOME/.local/share/settings --work-tree=$HOME"
	cd $HOME
	[ -d "$HOME/.local/share/settings" ] && exit
	git config --global credential.helper store
	git clone --bare https://github.com/MLR96/settings.git $HOME/.local/share/settings
	dot config --local status.showUntrackedFiles no
	dot restore --staged .
	dot restore .
	dot config user.name "Miguel López Ruiz"
	dot config user.email "miguel.lr96@gmail.com"

wsl:
	sudo install files/wsl/wsl.conf /etc/wsl.conf
	sudo install -m 0755 files/wsl/wslboot /usr/local/bin/wslboot

system-locale:
	sudo localectl set-locale LANG=en_US.UTF-8

locale:
	#!/usr/bin/env bash
	mkdir -p $HOME/Desktop
	mkdir -p $HOME/Downloads
	mkdir -p $HOME/Templates
	mkdir -p $HOME/Public
	mkdir -p $HOME/Documents
	mkdir -p $HOME/Music
	mkdir -p $HOME/Pictures
	mkdir -p $HOME/Videos
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

forticlient:
	sudo dnf config-manager --add-repo https://repo.fortinet.com/repo/7.0/centos/8/os/x86_64/fortinet.repo
	sudo yum install forticlient

projects:
	#!/usr/bin/env bash
	mkdir -p $HOME/Code; cd $HOME/Code
	git clone https://github.com/MLR96/settings.git
	git clone https://github.com/MLR96/workstation.git
	git clone https://github.com/MLR96/ldapproxy.git
	git clone https://github.com/MLR96/jwauto.git
	git clone https://github.com/MLR96/TimeManager.git

flatpak:
	flatpak --user remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
	flatpak --user install -y flathub com.brave.Browser
	flatpak --user install -y flathub com.google.Chrome
	flatpak --user install -y flathub com.microsoft.Edge
	flatpak --user install -y flathub org.chromium.Chromium
	flatpak --user install -y flathub org.freedesktop.Platform.ffmpeg-full
	flatpak --user install -y flathub org.keepassxc.KeePassXC
	flatpak --user install -y flathub com.github.tchx84.Flatseal
	flatpak --user install -y flathub org.mozilla.Thunderbird
	flatpak --user install -y flathub org.pulseaudio.pavucontrol
	flatpak --user install -y flathub com.calibre_ebook.calibre
	flatpak --user install -y flathub com.spotify.Client
	flatpak --user install -y flathub org.libreoffice.LibreOffice
	flatpak --user install -y flathub org.videolan.VLC
	flatpak --user install -y flathub org.gnome.Boxes
	flatpak --user install -y flathub com.usebottles.bottles
	flatpak --user install -y flathub org.telegram.desktop
	flatpak --user install -y flathub io.dbeaver.DBeaverCommunity
	flatpak --user install -y flathub org.gnome.Builder
	flatpak --user install -y https://downloads.1password.com/linux/flatpak/1Password.flatpakref || /bin/true

	flatpak --user install flathub com.mattjakeman.ExtensionManager
	flatpak --user install flathub org.gnome.Extensions
	flatpak --user install flathub ca.desrt.dconf-editor

	flatpak --user override --filesystem=xdg-data/themes
	flatpak --user override --filesystem=xdg-data/icons

packages:
	echo "Implement"

wallpapers:
	echo "Implement"

fonts:
	#!/usr/bin/env bash
	mkdir -p $HOME/.local/share/fonts
	cd $HOME/.local/share/fonts
	wget -nc -q -O JetBrainsMono.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip
	wget -nc -q -O SourceCodePro.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/SourceCodePro.zip
	unzip -o SourceCodePro.zip '*.ttf'
	unzip -o JetBrainsMono.zip '*.ttf'
	fc-cache

android:
	#!/usr/bin/env bash
	export ANDROID_HOME="$HOME/.local/share/android"
	export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"
	mkdir -p $ANDROID_HOME/cmdline-tools/latest; cd $ANDROID_HOME
	wget -nc -q -O cmdline-tools.zip 'https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip'
	bsdtar xvf cmdline-tools.zip --strip-components=1 -C cmdline-tools/latest # unzip cmdline-tools.zip 'cmdline-tools/*' -d 'cmdline-tools/latest'
	sdkmanager --install "platform-tools"
	sdkmanager --install "platforms;android-33"
	# sdkmanager --install "cmdline-tools;latest"

flutter:
	#!/usr/bin/env bash
	mkdir -p $HOME/.local/share/flutter; cd $HOME/.local/share/flutter
	wget -nc -q -O flutter.tar.xz 'https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.3-stable.tar.xz'
	rm -rf flutter/ &>/dev/null
	tar -xvf flutter.tar.xz
	mv flutter default

themes:
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
