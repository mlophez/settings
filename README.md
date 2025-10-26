# WORKSTATION

This is all needed to configure mi workstation or my personal laptop

---
## MAC OS

### Instal homebrew and gui apps

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install --cask container
container system start

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
keytool -importcert \
  -trustcacerts \
  -alias netskope \
  -file ~/.local/share/certificates/netskope.crt \
  -keystore ~/.local/share/certificates/netskope.jks \
  -storepass changeit

# VSCODE
# flutter

# INSTALAR FLUTTER
xcode-select --install
sudo xcodebuild -license accept
xcode-select -p

```

### NOTES

### SSH KEYS

### KEEPASSXC

### Instalar flutter, android-studio, xcode

