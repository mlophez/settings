# Install all nix packages in terminal
[group('Nix')]
nix-install:
  nix run home-manager/master -- --extra-experimental-features "nix-command flakes" switch --flake .#{{platform}} --impure

[group('Nix')]
nix-switch: && nix-clean
  home-manager --extra-experimental-features "nix-command flakes" switch --flake .#{{platform}} --impure --show-trace

[group('Nix')]
nix-packages:
  home-manager --extra-experimental-features "nix-command flakes" packages --flake .#{{platform}}  --impure

[group('Nix')]
nix-news:
  home-manager --extra-experimental-features "nix-command flakes" news --flake .#{{platform}}  --impure

[group('Nix')]
nix-upgrade: && nix-switch nix-clean
  nix flake update

[group('Nix')]
nix-clean:
  nix-collect-garbage --delete-old
