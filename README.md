# WORKSTATION

This is all needed to configure mi workstation or my personal laptop

```
mkdir Code
cd Code
git clone https://github.com/mlophez/settings.git Workstation
cd Workstation
just setup
```

## TASKS

- [ ] Instalar automaticamente el distrobox y flatpack
    - [ ] Instalar automaticamente nix
- [ ] Configurar dotfiles y gnome
- [ ] Configurar los repositorios
- [ ] Restaurar backup
- [ ] Configurar el navegador
- [ ] Configura el password manager

---
## LINUX

---
## MAC OS

### Instal homebrew and gui apps

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install --cask container
container system start

brew tap FelixKratz/formulae
brew install sketchybar

brew install --cask spaceid

brew tap hashicorp/tap
brew install hashicorp/tap/terraform

# Install nix from determinate
# Run home-manager first time
nix run home-manager/master -- --extra-experimental-features "nix-command flakes" switch --flake .#macos --impure

# Install raycast
brew install --cask raycast

# NETSKOPE
security find-certificate -a -p /System/Library/Keychains/SystemRootCertificates.keychain > ~/system-ca.pem
security find-certificate -a -p /Library/Keychains/System.keychain >> ~/system-ca.pem

CACERTS="$(dirname $(readlink -f $(which java)))/../lib/security/cacerts"
cp $CACERTS ~/.local/share/certificates/netskope.jks
keytool -list -keystore ~/.local/share/certificates/netskope.jks -storepass changeit | head
# Asegurarse de añadir la ca de netskope al jks
keytool -importcert \
  -trustcacerts \
  -alias netskope \
  -file ~/.local/share/certificates/netskope.ca.pem \
  -keystore ~/.local/share/certificates/netskope.jks \
  -storepass changeit

# Add to dbveaver
vim /Applications/DBeaver.app/Contents/Eclipse/dbeaver.ini
# -Djavax.net.ssl.trustStore=/Users/miguel.lopez/.local/share/certificates/netskope.jks
# -Djavax.net.ssl.trustStorePassword=changeit

# VSCODE
# flutter

# INSTALAR FLUTTER
xcode-select --install
sudo xcodebuild -license accept
xcode-select -p

```

### NOTES

### SSH KEYS y CREDS de aws

### KEEPASSXC

### Instalar flutter, android-studio, xcode

