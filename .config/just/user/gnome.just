# vim: ft=make

gnome-settings:
  dconf load / < $HOME/.config/gnome/settings.ini
  dconf load / < $HOME/.config/gnome/forge.ini

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

