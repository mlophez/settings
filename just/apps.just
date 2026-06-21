[group('Apps')]
install-claude:
  curl -fsSL https://claude.ai/install.sh | bash

[group('Apps')]
install-devbox:
  curl -fsSL https://get.jetify.com/devbox | bash

[group('Apps')]
install-kiro:
  curl -fsSL https://cli.kiro.dev/install | bash

# Configure server and login to self-hosted Bitwarden
[group('Apps')]
bw-login:
  bw config server https://bitwarden.zextime.com
  bw login

# Unlock vault and print session key (run: export BW_SESSION=$(bw unlock --raw))
[group('Apps')]
bw-unlock:
  @echo "Run this in your shell to export the session:"
  @echo '  export BW_SESSION=$(bw unlock --raw)'

[group('Apps')]
install-flutter:
  #!/usr/bin/env bash
  mkdir -p $HOME/.local/share/flutter; cd $HOME/.local/share/flutter

  curl -s 'https://storage.googleapis.com/flutter_infra_release/releases/releases_linux.json' -o /tmp/releases_linux.json
  hash=$(cat /tmp/releases_linux.json | jq -r '.current_release.stable')
  version=$(cat /tmp/releases_linux.json | jq -r ".releases[] | select(.hash == \"$hash\") | .archive")

  wget -nc -q -O flutter.tar.xz "https://storage.googleapis.com/flutter_infra_release/releases/$version"
  rm -rf flutter/ &>/dev/null
  tar -xvf flutter.tar.xz
  mv flutter default

# Upgrade flatpak apps
[group('Apps')]
upgrade-flatpak-apps:
  #!/usr/bin/env bash
  flatpak update -y

[group('Apps')]
upgrade-nvim-plugins:
  #!/usr/bin/env bash
  nvim --headless +Lazy! update +qa
