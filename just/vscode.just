# Extensiones de VS Code. El editor no expone un flag para actualizar todas, así
# que install usa --force (reinstala a la última publicada) y upgrade recorre lo
# que haya instalado.

# Install (or reinstall to the latest version) the working set of extensions
[group('VSCode')]
vscode-extensions-install:
	#!/usr/bin/env bash
	set -euo pipefail

	# Se omite en lugar de fallar: esta receta va encadenada en `just config` y
	# no toda máquina tiene VS Code instalado.
	if ! command -v code >/dev/null 2>&1; then
	  echo "VS Code no está instalado; omitiendo las extensiones."
	  exit 0
	fi

	code --install-extension ms-python.python --force
	code --install-extension golang.go --force
	code --install-extension dart-code.flutter --force

	code --install-extension esbenp.prettier-vscode --force
	code --install-extension mhutchie.git-graph --force
	code --install-extension ritwickdey.liveserver --force
	code --install-extension christian-kohler.path-intellisense --force
	code --install-extension formulahendry.auto-rename-tag --force
	code --install-extension pranaygp.vscode-css-peek --force
	code --install-extension dbaeumer.vscode-eslint --force
	code --install-extension zignd.html-css-class-completion --force
	code --install-extension bradlc.vscode-tailwindcss --force
	code --install-extension dsznajder.es7-react-js-snippets --force
	code --install-extension gruntfuggly.bettercommen --force
	code --install-extension glenn2223.live-sass --force
	code --install-extension astro-build.astro-vscode --force

	code --install-extension catppuccin.catppuccin-vsc --force
	code --install-extension pkief.material-icon-theme --force

# Update every installed extension to its latest version
[group('VSCode')]
vscode-extensions-upgrade:
	#!/usr/bin/env bash
	set -euo pipefail

	if ! command -v code >/dev/null 2>&1; then
	  echo "Error: code no está en el PATH. Instala VS Code primero." >&2
	  exit 1
	fi

	# VS Code no tiene '--update-extensions': se recorre la lista instalada y se
	# fuerza la reinstalación de cada una, que resuelve a la última publicada.
	code --list-extensions | xargs -L1 code --install-extension --force
