platform := os()
image := "localhost/workstation"

[private]
default:
  @just -u -l

# ============================================================
# TOP-LEVEL
# ============================================================

# Run all
setup:
  @just {{platform}}-setup
  npm -g install tree-sitter-cli
  # cargo install --locked tree-sitter-cli

# Upgrade all in terminal, packages nvim plugins etc.
upgrade:
  @just {{platform}}-upgrade-terminal
  npm -g install tree-sitter-cli

claude-install:
  curl -fsSL https://claude.ai/install.sh | bash

claude-setup:
  claude plugin marketplace add JuliusBrussee/caveman
  claude plugin install caveman@caveman

kiro-install:
  curl -fsSL https://cli.kiro.dev/install | bash

# ============================================================
# LINUX
# ============================================================

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
linux-setup-backgrounds:
  #!/usr/bin/env bash
  mkdir -p $HOME/.local/share/backgrounds
  cp -rf local/share/backgrounds/* $HOME/.local/share/backgrounds/

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

linux-setup-flutter-development:
  #!/usr/bin/env bash
  mkdir -p $HOME/.local/share/flutter; cd $HOME/.local/share/flutter

  curl -s 'https://storage.googleapis.com/flutter_infra_release/releases/releases_linux.json' -o /tmp/releases_linux.json
  hash=$(cat /tmp/releases_linux.json | jq -r '.current_release.stable')
  version=$(cat /tmp/releases_linux.json | jq -r ".releases[] | select(.hash == \"$hash\") | .archive")

  wget -nc -q -O flutter.tar.xz "https://storage.googleapis.com/flutter_infra_release/releases/$version"
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

[private]
linux-upgrade-terminal:
  @just upgrade-archlinux
  @just upgrade-flatpak
  @just nvim-upgrade-plugins

upgrade-archlinux:
  #!/usr/bin/env bash
  sudo pacman -Syu --noconfirm

upgrade-flatpak:
  #!/usr/bin/env bash
  flatpak update -y

nvim-upgrade-plugins:
  #!/usr/bin/env bash
  nvim --headless +Lazy! update +qa

# ============================================================
# MACOS
# ============================================================

[private]
mac-setup:
  @just nix-install

macos-upgrade-terminal: nix-upgrade

# Limpia cachés del sistema para liberar espacio en disco
clean:
  @echo "Limpiando cachés de navegadores..."
  rm -rf ~/Library/Caches/BraveSoftware
  rm -rf ~/Library/Caches/Firefox
  rm -rf ~/Library/Caches/Google
  @echo "Limpiando cachés de Go..."
  rm -rf ~/Library/Caches/go-build
  rm -rf ~/Library/Caches/goimports
  rm -rf ~/Library/Caches/gopls
  @echo "Limpiando caché de Poetry..."
  rm -rf ~/Library/Caches/pypoetry
  @echo "Limpiando Homebrew..."
  brew cleanup
  @echo "Limpiando cachés de Gradle..."
  rm -rf ~/.gradle/caches
  @echo "Limpiando Podman..."
  podman machine start || true
  podman system prune -a --volumes -f
  @echo "Limpiando VM de Claude Code..."
  rm -rf ~/Library/Application\ Support/Claude/vm_bundles
  @echo "Limpiando módulos de Go..."
  go clean -modcache
  @echo "Limpiando Terraform plugin cache..."
  rm -rf ~/.local/share/terraform/plugin-cache/*
  @echo "Listo."

[private]
netskope:
  mkdir -p $HOME/.local/share/certificates
  echo | openssl s_client -connect oidc.eu-west-1.amazonaws.com:443 -servername oidc.eu-west-1.amazonaws.com 2>/dev/null | openssl x509 -outform PEM > $HOME/.local/share/certificates/netskope.crt

# ============================================================
# NIX / HOME-MANAGER
# ============================================================

# Install all nix packages in terminal
nix-install:
  nix run home-manager/master -- --extra-experimental-features "nix-command flakes" switch --flake .#{{platform}} --impure

nix-switch: && nix-clean
  home-manager --extra-experimental-features "nix-command flakes" switch --flake .#{{platform}} --impure --show-trace

nix-packages:
  home-manager --extra-experimental-features "nix-command flakes" packages --flake .#{{platform}}  --impure

nix-news:
  home-manager --extra-experimental-features "nix-command flakes" news --flake .#{{platform}}  --impure

nix-upgrade: && nix-switch nix-clean
  nix flake update

nix-clean:
  nix-collect-garbage --delete-old

# ============================================================
# DISTROBOX
# ============================================================

[private]
distrobox-setup: && distrobox-autostart
  -distrobox rm archlinux -f

  distrobox-create --nvidia -Y -n archlinux --image ghcr.io/ublue-os/arch-distrobox:latest

  distrobox enter archlinux -- sudo pacman-key --init
  distrobox enter archlinux -- sudo pacman -Syu --noconfirm
  distrobox enter archlinux -- sudo pacman --needed --noconfirm -S wezterm code nix
  distrobox enter archlinux -- sudo pacman --needed --noconfirm -S $(cat $(pwd)/packages/archlinux.lst | grep -v "^ *#" | tr '\n' ' ')

  distrobox enter archlinux -- sudo ln -sf /usr/sbin/distrobox-host-exec /usr/bin/distrobox
  distrobox enter archlinux -- sudo ln -sf /usr/sbin/distrobox-host-exec /usr/bin/podman
  distrobox enter archlinux -- sudo ln -sf /usr/sbin/distrobox-host-exec /usr/bin/flatpak
  distrobox enter archlinux -- sudo ln -sf /usr/sbin/distrobox-host-exec /usr/bin/gsettings
  # distrobox enter archlinux -- sudo ln -sf /usr/sbin/distrobox-host-exec /usr/bin/dconf

  distrobox enter archlinux -- sudo ln -sf /run/host/usr/share/ublue-os /usr/share/ublue-os

  distrobox enter archlinux -- distrobox-export --app wezterm
  distrobox enter archlinux -- distrobox-export --app code

[private]
distrobox-autostart:
  #!/bin/bash
  mkdir -p $HOME/.config/autostart/
  cat << EOF > $HOME/.config/autostart/archlinux.desktop
  [Desktop Entry]
  Name=Archlinux
  Comment=Archlinux Distrobox
  Exec=/bin/bash -c 'distrobox enter archlinux -- echo'
  Type=Application
  EOF

[private]
distrobox-host-alias:
  sudo ln -sf /usr/sbin/distrobox-host-exec /usr/bin/distrobox
  sudo ln -sf /usr/sbin/distrobox-host-exec /usr/bin/podman
  sudo ln -sf /usr/sbin/distrobox-host-exec /usr/bin/flatpak
  sudo ln -sf /usr/sbin/distrobox-host-exec /usr/bin/gsettings
  sudo ln -sf /usr/sbin/distrobox-host-exec /usr/bin/dconf
  sudo ln -sf /usr/sbin/distrobox-host-exec /usr/bin/rofi

[private]
distrobox-export-apps:
  type alacritty &>/dev/null && distrobox-export --bin /usr/bin/alacritty --export-path $HOME/.local/bin
  type kitty &>/dev/null && distrobox-export --bin /usr/bin/kitty --export-path $HOME/.local/bin
  type code &>/dev/null && distrobox-export --app code

# ============================================================
# BOOTC (Bluefin derivation)
# ============================================================

# Build local bootc image from Containerfile (tag = YYYYMMDD + latest)
bootc-build:
  #!/usr/bin/env bash
  set -euo pipefail
  tag="$(date +%Y%m%d)"
  cpus=$(( $(nproc) / 2 ))
  sudo podman build --pull=newer \
    --squash \
    --retry=5 --retry-delay=10s \
    --cpu-shares=2 \
    -t {{image}}:"${tag}" \
    -t {{image}}:latest \
    -f Containerfile .

# Rebase running system to the local image (first-time switch)
bootc-switch:
  sudo bootc switch --transport containers-storage {{image}}:latest

# Show current bootc deployment status
bootc-status:
  sudo bootc status

# Rollback to previous deployment
bootc-rollback:
  sudo bootc rollback

# List local images built for this workstation
bootc-images:
  sudo podman images {{image}}

# Prune old local images (keep latest + today's date tag)
bootc-prune:
  #!/usr/bin/env bash
  set -euo pipefail
  keep="$(date +%Y%m%d)"
  sudo podman images --format '{{{{.Repository}}:{{{{.Tag}}' {{image}} \
    | grep -v -E ":(latest|${keep})$" \
    | xargs -r -n1 sudo podman rmi -f

# Rebuild local image and apply with bootc upgrade
upgrade-system: bootc-build
  sudo bootc upgrade

# ============================================================
# SETTINGS (dotfiles, repos)
# ============================================================

# Configure symlinks for config files
dotfiles:
  #!/bin/bash
  install () {
    local src=$1
    local dest=$2
    [[ -d $dest ]] && rm -r "$dest"
    [[ -f $dest ]] && rm "$dest"
    echo $src - $dest
    mkdir -p "$(dirname "$dest")"
    ln -sf "$src" "$dest"
  }
  install $(pwd) $HOME/.local/share/settings
  # TERMINAL AND SHELL
  install $(pwd)/config/wezterm $HOME/.config/wezterm
  install $(pwd)/config/fish $HOME/.config/fish
  install $(pwd)/config/starship.toml $HOME/.config/starship.toml
  install $(pwd)/config/zellij $HOME/.config/zellij
  install $(pwd)/config/nvim $HOME/.config/nvim
  # OTHERS
  install $(pwd)/config/zsh $HOME/.config/zsh
  install $(pwd)/config/zsh/zshrc $HOME/.zshrc
  install $(pwd)/config/zsh/zshenv $HOME/.zshenv
  install $(pwd)/config/zsh/zprofile $HOME/.zprofile
  install $(pwd)/config/nix $HOME/.config/nix
  install $(pwd)/config/git $HOME/.config/git
  install $(pwd)/config/k9s $HOME/.config/k9s
  install $(pwd)/config/ngrok $HOME/.config/ngrok
  install $(pwd)/config/just $HOME/.config/just
  install $(pwd)/config/kube/config $HOME/.config/kube/config
  install $(pwd)/config/aws/config $HOME/.aws/config
  install $(pwd)/config/ssh/config $HOME/.ssh/config
  install $(pwd)/config/containers $HOME/.config/containers
  # install $(pwd)/local/bin/docker-wrapper.sh $HOME/.local/bin/docker
  # CLAUDE
  install $(pwd)/config/claude/CLAUDE.md $HOME/.claude/CLAUDE.md
  install $(pwd)/config/claude/skills $HOME/.claude/skills
  install $(pwd)/config/claude/commands $HOME/.claude/commands
  install $(pwd)/config/claude/settings.json $HOME/.claude/settings.json
  # OPENCODE
  install $(pwd)/config/opencode $HOME/.config/opencode
  # PLATFORM SPECIFIC
  if [[ "{{platform}}" == "macos" ]]; then
    install $(pwd)/config/k9s "$HOME/Library/Application Support/k9s"
    install $(pwd)/config/ngrok "$HOME/Library/Application Support/ngrok"
    ln -sf /opt/podman/bin/podman $HOME/.local/bin/docker
    # install $(pwd)/local/bin/docker-wrapper.sh $HOME/.local/bin/podman
  fi

# Get Git Repositories
clone-repositories:
  #!/usr/bin/env bash
  clone () {
    local repo=$1
    local path=$2
    [[ -d $path ]] && return
    git clone $repo $path
  }
  mkdir -p $HOME/Code; cd $HOME/Code
  clone https://github.com/MLR96/settings.git Workstation
  clone https://github.com/MLR96/ldapproxy.git LDAPProxy
  clone https://github.com/mlophez/chroniq.git Chroniq
  #clone https://mlophez@bitbucket.org/firmapro/sealed-secret-app.git SealedSecretsApp
  clone https://github.com/mlophez/turnix.git Zitania
  clone https://github.com/mlophez/kubeops-agent.git KubeOpsAgent

# ============================================================
# GNOME
# ============================================================

[private]
gnome-load-settings: && gnome-set-keybinds
  dconf load / < ./gnome/settings.ini

[private]
gnome-set-keybinds:
  #!/usr/bin/env bash
  # Clear existing keybindings
  gsettings list-keys org.gnome.desktop.wm.keybindings | xargs -I@ gsettings set org.gnome.desktop.wm.keybindings @ "[]"
  gsettings list-keys org.gnome.shell.keybindings | xargs -I@ gsettings set org.gnome.shell.keybindings @ "[]"
  # Load keybindings from file
  dconf load / < ./gnome/keybindings.ini

[private]
gnome-forge-keybinds-reset:
  # gsettings list-keys org.gnome.desktop.wm.keybindings | xargs -I@ gsettings reset org.gnome.desktop.wm.keybindings @
  # gsettings list-keys org.gnome.shell.keybindings | xargs -I@ gsettings reset org.gnome.shell.keybindings @
  # FORGE="$HOME/.local/share/gnome-shell/extensions/forge@jmmaranan.com/schemas"
  #if [ -d ${FORGE} ]; then
  #  gsettings --schemadir ${FORGE} list-keys org.gnome.shell.extensions.forge.keybindings | \
  #    xargs -I% gsettings --schemadir ${FORGE} set org.gnome.shell.extensions.forge.keybindings % "[]"
  #fi

[private]
gnome-disable-services:
	#!/usr/bin/env bash
	regex=$(cat << EOF | tr -d '\n' | tr -d ' ' | tr -d '\t'
	^(
			org.gnome.SettingsDaemon.*|
			user-dirs-update-gtk.desktop|
			xdg-user-dirs.desktop
	)
	EOF
	)

	sudo rm -rf /etc/xdg/autostart/*.desktop &>/dev/null
	for service in $(ls /usr/etc/xdg/autostart); do
		[[ ! $service =~ $regex ]] && continue
		sudo cp -p /usr/etc/xdg/autostart/$service /etc/xdg/autostart/$service
	done

[private]
gnome-disable-services2:
	#!/usr/bin/env bash
	regex=$(cat << EOF | tr -d '\n' | tr -d ' ' | tr -d '\t'
	^(
			org.gnome.evolution.*|
			org.gnome.OnlineAccounts.service|
			org.gnome.Identity.service|
			org.gtk.vfs.GoaVolumeMonitor.service
	)
	EOF
	)
	for service in $(ls /usr/share/dbus-1/services); do
		[[ ! $service =~ $regex ]] && continue
		# ln -snf /dev/null $HOME/.local/share/dbus-1/services/${service}
		# cp -f /usr/share/dbus-1/services/${service} $HOME/.local/share/dbus-1/services/${service}
		# sed 's/^Exec.*/Exec=exit/g' -i $HOME/.local/share/dbus-1/services/${service}
		# rm $HOME/.local/share/dbus-1/services/${service}
	done

# ============================================================
# BACKUP
# ============================================================

backup:
  #!/bin/bash
  distrobox-host-exec sudo bash -c << 'EOF'
    DISK=$(blkid -U 77a01e45-e966-48f0-90c3-73589b397528)
    MOUNTPOINT=/mnt/backup

    sudo mkdir -p $MOUNTPOINT
    [[ mountpoint -q $MOUNTPOINT ]] || sudo mount $DISK $MOUNTPOINT

    ls -lah $MOUNTPOINT/
    umount $MOUNTPOINT
  EOF
