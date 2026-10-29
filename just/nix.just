# Build the package environment and set it as the current Nix profile
[group('Nix')]
nix-switch: && nix-fonts
  #!/usr/bin/env bash
  set -euo pipefail

  # No se deduce de XDG_STATE_HOME: Nix fija la ruta del perfil al instalarse
  # y no vuelve a leer esa variable. Se pregunta al propio symlink.
  default_profile="$HOME/.local/state/nix/profiles/profile"
  if [[ -L $HOME/.nix-profile ]]; then
    profile=$(readlink "$HOME/.nix-profile")
    # Symlink obsoleto (p. ej. /var/home/<user>, del antiguo layout ostree donde
    # el home real vivía en /var/home): si el directorio del perfil ya no
    # existe, volver al path por defecto y reparar ~/.nix-profile, que el PATH
    # de fish/zsh referencia.
    if [[ ! -d $(dirname "$profile") ]]; then
      echo "Stale ~/.nix-profile -> $profile; relinking to $default_profile"
      profile="$default_profile"
      ln -sfn "$profile" "$HOME/.nix-profile"
    fi
  else
    profile="$default_profile"
  fi

  echo "Building the package environment..."
  env_path=$(nix build --no-link --print-out-paths .#default)

  echo "Setting profile $profile -> $env_path"
  nix-env --profile "$profile" --set "$env_path"

# List the packages currently installed in the profile
[group('Nix')]
nix-packages:
  #!/usr/bin/env bash
  set -euo pipefail

  ls "$HOME/.nix-profile/bin" | sort

# List the profile generations, newest last, marking the current one
[group('Nix')]
nix-generations:
  #!/usr/bin/env bash
  set -euo pipefail

  # Same resolution as nix-switch: the profile path is fixed at install time,
  # so it is read from the symlink instead of being derived from XDG_STATE_HOME.
  if [[ -L $HOME/.nix-profile ]]; then
    profile=$(readlink "$HOME/.nix-profile")
  else
    profile="$HOME/.local/state/nix/profiles/profile"
  fi

  nix-env --profile "$profile" --list-generations

# Update flake.lock to the latest nixpkgs and apply it
[group('Nix')]
nix-upgrade: && nix-switch nix-clean
  nix flake update

# Write the workstation settings into the Nix daemon config and restart it
[group('Nix')]
nix-custom:
  #!/usr/bin/env bash
  set -euo pipefail

  # nix.custom.conf es el fichero que el instalador de Determinate reserva para
  # cambios del usuario: nix.conf se reescribe en cada actualización.
  conf=/etc/nix/nix.custom.conf
  begin="# BEGIN workstation (just nix-custom)"
  end="# END workstation (just nix-custom)"

  if ! rg -q '^!include nix.custom.conf' /etc/nix/nix.conf; then
    echo "/etc/nix/nix.conf does not include nix.custom.conf; nothing to do" >&2
    exit 1
  fi

  # Bundle de CAs que ya usa el propio daemon. En macOS Determinate lo genera
  # desde el llavero, así que incluye la CA de Netskope cuando está instalada.
  cert=$(nix config show ssl-cert-file)
  if [[ -z $cert || ! -r $cert ]]; then
    echo "ssl-cert-file is not set or not readable: '$cert'" >&2
    exit 1
  fi

  # impure-env pasa NIX_SSL_CERT_FILE a las derivaciones fixed-output (fetchers,
  # módulos Go, npm...). Sin ello usan el bundle de cacert, que no trae la CA de
  # Netskope, y fallan con "certificate signed by unknown authority".
  block=$(cat <<EOF
  $begin
  extra-experimental-features = configurable-impure-env
  impure-env = NIX_SSL_CERT_FILE=$cert
  $end
  EOF
  )

  # Bloque gestionado actual (vacío si aún no existe): si coincide, no se toca
  # nada ni se reinicia el daemon.
  current=$(awk -v b="$begin" -v e="$end" '$0 == b {f = 1} f {print} $0 == e {f = 0}' "$conf" 2>/dev/null || true)
  if [[ $current == "$block" ]]; then
    echo "$conf is already up to date"
    exit 0
  fi

  # Se reconstruye el fichero: todo lo ajeno al bloque se conserva tal cual y el
  # bloque se añade al final con el contenido nuevo.
  tmp=$(mktemp)
  trap 'rm -f "$tmp"' EXIT
  awk -v b="$begin" -v e="$end" '$0 == b {f = 1} !f {print} $0 == e {f = 0}' "$conf" > "$tmp" 2>/dev/null || true
  printf '%s\n' "$block" >> "$tmp"

  echo "Writing $conf (requires sudo)"
  sudo install -m 644 "$tmp" "$conf"

  # El daemon solo lee la configuración al arrancar
  echo "Restarting the Nix daemon"
  if [[ "$(uname -s)" == "Darwin" ]]; then
    for label in systems.determinate.nix-daemon org.nixos.nix-daemon; do
      if [[ -f /Library/LaunchDaemons/$label.plist ]]; then
        sudo launchctl kickstart -k "system/$label"
      fi
    done
  else
    sudo systemctl restart nix-daemon
  fi

# Sync fonts into ~/Library/Fonts on macOS (no-op elsewhere)
[group('Nix')]
[private]
nix-fonts:
  #!/usr/bin/env bash
  set -euo pipefail

  # Only macOS needs this: fontconfig on Linux already picks up the profile.
  [[ "$(uname -s)" == "Darwin" ]] || exit 0

  src="$HOME/.nix-profile/share/fonts"
  dst="$HOME/Library/Fonts/Nix"
  [[ -d $src ]] || exit 0

  echo "Syncing fonts into $dst"
  mkdir -p "$dst"
  rsync -acL --chmod=u+w --delete "$src/" "$dst/"

# Keep only the two most recent generations and collect garbage
[group('Nix')]
nix-clean:
  #!/usr/bin/env bash
  set -euo pipefail

  # Same resolution as nix-switch: the profile path is fixed at install time,
  # so it is read from the symlink instead of being derived from XDG_STATE_HOME.
  if [[ -L $HOME/.nix-profile ]]; then
    profile=$(readlink "$HOME/.nix-profile")
  else
    profile="$HOME/.local/state/nix/profiles/profile"
  fi

  # +2 keeps the two newest generations (the current one and one rollback step)
  # and deletes the rest. Targets this profile only, unlike --delete-older-than.
  echo "Deleting all but the two most recent generations of $profile"
  nix-env --profile "$profile" --delete-generations +2

  # Second phase: sweep the store paths no generation references anymore
  nix-collect-garbage
