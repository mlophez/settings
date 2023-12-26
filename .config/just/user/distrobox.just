# vim: ft=make

distrobox: distrobox-fedora distrobox-archlinux

distrobox-fedora:
	echo 'Creating fedora distrobox ...'
	distrobox-create --nvidia -Y -n fedora --image ghcr.io/ublue-os/fedora-distrobox:latest

distrobox-archlinux:
	echo 'Creating archlinux distrobox ...'
	distrobox-create --nvidia -Y -n archlinux --image ghcr.io/ublue-os/arch-distrobox:latest

	distrobox enter archlinux -- sudo pacman -Syu
	distrobox enter archlinux -- sudo pacman --needed -S $(cat $HOME/.config/distrobox/archlinux.txt | grep -v "^ *#" | tr '\n' ' ')
	distrobox enter archlinux -- sudo pacman --needed -S alacritty kitty code
	distrobox enter archlinux -- sudo pacman --needed -S ttf-jetbrains-mono-nerd
	distrobox enter archlinux -- sudo pacman -Scc

	distrobox enter archlinux -- sudo ln -sf /usr/sbin/distrobox-host-exec /usr/bin/distrobox
	distrobox enter archlinux -- sudo ln -sf /usr/sbin/distrobox-host-exec /usr/bin/podman
	distrobox enter archlinux -- sudo ln -sf /usr/sbin/distrobox-host-exec /usr/bin/flatpak
	distrobox enter archlinux -- sudo ln -sf /run/host/usr/share/ublue-os /usr/share/ublue-os

	distrobox enter archlinux -- distrobox-export --bin /usr/bin/alacritty --export-path $HOME/.local/bin
	distrobox enter archlinux -- distrobox-export --bin /usr/bin/kitty --export-path $HOME/.local/bin

distrobox-anbox:
	echo 'Creating anbox distrobox ...'
	distrobox-create --nvidia -Y -n anbox --image ghcr.io/ublue-os/arch-distrobox:latest

distrobox-host-alias:
	sudo ln -sf /usr/sbin/distrobox-host-exec /usr/bin/distrobox
	sudo ln -sf /usr/sbin/distrobox-host-exec /usr/bin/podman
	sudo ln -sf /usr/sbin/distrobox-host-exec /usr/bin/flatpak
	sudo ln -sf /usr/sbin/distrobox-host-exec /usr/bin/gsettings
	sudo ln -sf /usr/sbin/distrobox-host-exec /usr/bin/dconf
	sudo ln -sf /usr/sbin/distrobox-host-exec /usr/bin/rofi

distrobox-export-apps:
	type alacritty &>/dev/null && distrobox-export --bin /usr/bin/alacritty --export-path $HOME/.local/bin
	type kitty &>/dev/null && distrobox-export --bin /usr/bin/kitty --export-path $HOME/.local/bin
	type code &>/dev/null && distrobox-export --app code
