# My Settings dot files

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install --cask container
container system start

# Install nix from determinate

nix flake init -t github:LnL7/nix-darwin#minimal

nix profile install .#default
nix profile install nixpkgs#neovim
nix profile install nixpkgs#stow
```
