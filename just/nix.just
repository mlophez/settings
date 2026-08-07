# Build the package environment and set it as the current Nix profile
[group('Nix')]
nix-switch: && nix-fonts
  #!/usr/bin/env bash
  set -euo pipefail

  # No se deduce de XDG_STATE_HOME: Nix fija la ruta del perfil al instalarse
  # y no vuelve a leer esa variable. Se pregunta al propio symlink.
  if [[ -L $HOME/.nix-profile ]]; then
    profile=$(readlink "$HOME/.nix-profile")
  else
    profile="$HOME/.local/state/nix/profiles/profile"
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

# Sync fonts into ~/Library/Fonts on macOS (no-op elsewhere)
[group('Nix')]
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
