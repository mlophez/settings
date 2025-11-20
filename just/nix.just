# Install all nix packages in terminal
nix-install:
  nix run home-manager/master -- --extra-experimental-features "nix-command flakes" switch --flake .#{{platform}} --impure

nix-switch: && nix-clean
  home-manager --extra-experimental-features "nix-command flakes" switch --flake .#{{platform}} --impure --show-trace

nix-packages:
  home-manager --extra-experimental-features "nix-command flakes" packages --flake .#{{platform}}  --impure

nix-news:
  home-manager --extra-experimental-features "nix-command flakes" news --flake .#{{platform}}  --impure

nix-upgrade: && nix-switch nix-clean
  nix flake update

nix-clean:
  nix-collect-garbage --delete-old

