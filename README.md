# My Settings dot files

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install --cask container
container system start

# Install nix from determinate
# Run home-manager first time
nix run home-manager/master -- --extra-experimental-features "nix-command flakes" switch --flake .#macos --impure

```



