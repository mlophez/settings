# Setup macos
mac-setup: mac-nix-install mac-nix-switch

linux-nix-install:
  nix run home-manager/master -- --extra-experimental-features "nix-command flakes" switch --flake .#linux --impure

# Install all nix packages in terminal
mac-nix-install:
  nix run home-manager/master -- --extra-experimental-features "nix-command flakes" switch --flake .#macos --impure

mac-nix-switch: && nix-clean
  home-manager --extra-experimental-features "nix-command flakes" switch --flake .#macos --impure --show-trace

mac-nix-packages:
  home-manager --extra-experimental-features "nix-command flakes" packages --flake .#macos  --impure

mac-nix-news:
  home-manager --extra-experimental-features "nix-command flakes" news --flake .#macos  --impure

nix-upgrade: && mac-nix-switch nix-clean
  nix flake update

[private]
netskope:
  mkdir -p $HOME/.local/share/certificates
  echo | openssl s_client -connect oidc.eu-west-1.amazonaws.com:443 -servername oidc.eu-west-1.amazonaws.com 2>/dev/null | openssl x509 -outform PEM > $HOME/.local/share/certificates/netskope.crt



