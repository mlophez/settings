# Bitwarden CLI. El binario `bw` lo aporta Nix (nix/packages.nix): aquí solo
# viven las recetas de sesión contra el servidor self-hosted.

# Configure server and login to self-hosted Bitwarden
[group('Bitwarden')]
bitwarden-login:
  bw config server https://bitwarden.zextime.com
  bw login

# Unlock vault and print session key (run: export BW_SESSION=$(bw unlock --raw))
[group('Bitwarden')]
bitwarden-unlock:
  @echo "Run this in your shell to export the session:"
  @echo '  export BW_SESSION=$(bw unlock --raw)'
