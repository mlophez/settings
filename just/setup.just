[private]
[group('Settings')]
system-setup-linux:
  # Setup gnome
  @just gnome-load-config
  # Install gui apps
  @just flatpak-install
  # Install distroboxes
  @just distrobox-setup
  #@just nix-install
  # Configure dotfiles
  @just config

[private]
[group('System')]
system-setup-macos:
  @just nix-switch

[private]
[group('System')]
system-install-fonts:
	#!/usr/bin/env bash
	mkdir -p $HOME/.local/share/fonts
	cd $HOME/.local/share/fonts
	wget -nc -q -O JetBrainsMono.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip
	wget -nc -q -O SourceCodePro.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/SourceCodePro.zip
	unzip -o SourceCodePro.zip '*.ttf'
	unzip -o JetBrainsMono.zip '*.ttf'
	fc-cache

[private]
[group('System')]
system-install-backgrounds:
  #!/usr/bin/env bash
  mkdir -p $HOME/.local/share/backgrounds
  cp -rf local/share/backgrounds/* $HOME/.local/share/backgrounds/

[private]
[group('System')]
system-install-cursors:
  #!/usr/bin/env bash
  # Extract versioned cursor theme tarballs into the user icon dir (XDG: ~/.local/share/icons/<theme>/)
  # Activate one with: gsettings set org.gnome.desktop.interface cursor-theme 'oreo_black_cursors'
  mkdir -p $HOME/.local/share/icons
  for archive in local/share/cursors/*.tar.gz; do
    [ -e "$archive" ] || continue
    echo "Extracting ${archive}"
    tar xzf "$archive" -C $HOME/.local/share/icons/
  done

[private]
[group('System')]
system-install-android:
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
[group('System')]
system-install-gtk-themes:
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
[group('System')]
system-install-netskope:
  mkdir -p $HOME/.local/share/certificates
  echo | openssl s_client -connect oidc.eu-west-1.amazonaws.com:443 -servername oidc.eu-west-1.amazonaws.com 2>/dev/null | openssl x509 -outform PEM > $HOME/.local/share/certificates/netskope.crt

# Setup linux locale and user dirs
[private]
[group('System')]
system-set-locale:
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

[private]
[group('System')]
system-upgrade-terminal-linux:
  @just system-upgrade
  @just distrobox-upgrade
  @just flatpak-upgrade
  @just nvim-upgrade

[private]
[group('System')]
system-upgrade-terminal-macos: nix-upgrade
