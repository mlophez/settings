# vim: ft=make

gnome-settings:
	dconf load / < $HOME/.config/gnome/settings.ini
	dconf load / < $HOME/.config/gnome/forge.ini
	dconf load / < $HOME/.config/gnome/terminal.ini

gnome-keybindings:
	#!/usr/bin/env bash
	echo "SETTINGS GNOME KEYBINDINGS"

	# gsettings list-keys org.gnome.desktop.wm.keybindings | xargs -I@ gsettings reset org.gnome.desktop.wm.keybindings @
	# gsettings list-keys org.gnome.shell.keybindings | xargs -I@ gsettings reset org.gnome.shell.keybindings @

	FORGE="$HOME/.local/share/gnome-shell/extensions/forge@jmmaranan.com/schemas"

	gsettings list-keys org.gnome.desktop.wm.keybindings | \
	  xargs -I@ gsettings set org.gnome.desktop.wm.keybindings @ "[]"

	gsettings list-keys org.gnome.shell.keybindings | \
	  xargs -I@ gsettings set org.gnome.shell.keybindings @ "[]"

	if [ -d ${FORGE} ]; then
	  gsettings --schemadir ${FORGE} list-keys org.gnome.shell.extensions.forge.keybindings | \
	    xargs -I% gsettings --schemadir ${FORGE} set org.gnome.shell.extensions.forge.keybindings % "[]"
	fi

	dconf load / < $HOME/.config/gnome/keybindings.ini

gnome-load-themes:
	#!/usr/bin/env bash
	echo implement

gnome-save-themes:
	#!/usr/bin/env bash
	echo implement


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

