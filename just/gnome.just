# Apply all GNOME config from config/gnome/*.ini (dconf load is selective: only the keys present in each file are written)
[group('Gnome')]
gnome-load-config: && gnome-load-keybinds
  #!/usr/bin/env bash
  set -euo pipefail
  # Load every .ini except keybindings (handled separately with a clean slate)
  for file in config/gnome/*.ini; do
    [ -e "$file" ] || continue
    [ "$(basename "$file")" = "keybindings.ini" ] && continue
    echo "Loading ${file}"
    dconf load / < "$file"
  done

# Dump the dedicated extension subtrees into config/gnome/*.ini (settings.ini and keybindings.ini are hand-edited)
[group('Gnome')]
gnome-save-config:
  # dconf dump uses headers relative to the dumped path; the sed rewrites them to absolute so `dconf load /` works.
  # The `t` after the first substitution skips the second one, avoiding a double prefix on the rewritten header.
  dconf dump /org/gnome/terminal/ | sed -E 's,^\[/\],[org/gnome/terminal],;t;s,^\[([^/].*)\],[org/gnome/terminal/\1],' > config/gnome/terminal.ini
  dconf dump /org/gnome/shell/extensions/forge/ | sed -E 's,^\[/\],[org/gnome/shell/extensions/forge],;t;s,^\[([^/].*)\],[org/gnome/shell/extensions/forge/\1],' > config/gnome/forge.ini
  dconf dump /org/gnome/shell/extensions/search-light/ | sed -E 's,^\[/\],[org/gnome/shell/extensions/search-light],;t;s,^\[([^/].*)\],[org/gnome/shell/extensions/search-light/\1],' > config/gnome/search-light.ini

# Clear default wm/shell keybindings and apply only the ones in config/gnome/keybindings.ini
[group('Gnome')]
gnome-load-keybinds:
  #!/usr/bin/env bash
  set -euo pipefail
  # Reset existing bindings so only ours remain (avoids leftover defaults conflicting)
  gsettings list-keys org.gnome.desktop.wm.keybindings | xargs -I@ gsettings set org.gnome.desktop.wm.keybindings @ "[]"
  gsettings list-keys org.gnome.shell.keybindings | xargs -I@ gsettings set org.gnome.shell.keybindings @ "[]"
  # Load our keybindings from file
  echo "Loading config/gnome/keybindings.ini"
  dconf load / < config/gnome/keybindings.ini

[private]
[group('Settings')]
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
[group('Settings')]
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
