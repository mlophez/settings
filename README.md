# WORKSTATION

Repositorio personal de configuración versionada de la workstation (Linux y macOS) de Miguel.

No es código de aplicación: contiene dotfiles, configuración de sistema, un Containerfile bootc derivado de Bluefin y un orquestador en `just` para reconstruir todo el entorno desde cero en una máquina nueva.

## Para qué sirve

- **Linux (Bluefin/ublue):** mantener una imagen OCI bootc derivada de `ghcr.io/ublue-os/bluefin:gts` con paquetes y configuración adicionales. El sistema arranca directamente de esa imagen (modelo *image-based OS* de bootc).
- **macOS:** instalar paquetes CLI vía Nix Home Manager + apps gráficas vía Homebrew.
- **Ambas plataformas:** enlazar todos los dotfiles (`config/*`), scripts (`bin/*`) y configuración de sistema (`default/*`) mediante symlinks idempotentes al `$HOME` y `/etc/` correspondientes.

## Arquitectura

Tres jerarquías versionadas, todas mapeadas al sistema mediante symlinks creados por `just dotfiles`:

- `config/` → dotfiles de usuario (enlazados a `$HOME` y `~/.config/<app>`).
- `default/` → configuración de sistema (enlazados a `/etc/<path>`, requiere `sudo`).
- `bin/` → scripts ejecutables del usuario (enlazados a `$HOME/.local/bin/<script>`).

Además:
- `Containerfile` → derivación bootc desde Bluefin GTS (solo Linux ublue).
- `flake.nix` + `nix/` → configuración Home Manager para `linux` y `macos`.
- `Justfile` → orquestador único con todas las recetas organizadas por secciones.

---

## LINUX (Bluefin / ublue)

### 1. Instalar la distro oficial de ublue

Antes de nada, la máquina necesita una base bootc-compatible. Descargar e instalar Bluefin desde:

https://projectbluefin.io/

Variantes recomendadas:
- **Bluefin GTS** (estable, Fedora N-2) → es la base de este repo.
- Bluefin DX si quieres herramientas dev preinstaladas.

Tras la instalación inicial y el primer login, comprobar que el sistema es bootc:

```bash
sudo bootc status
```

### 2. Clonar este repositorio

```bash
mkdir -p ~/Code
cd ~/Code
git clone https://github.com/mlophez/settings.git Workstation
cd Workstation
```

### 3. Construir e instalar la imagen derivada

Primera vez (build + rebase):

```bash
just bootc-build      # construye localhost/workstation:YYYYMMDD + :latest
just bootc-switch     # rebase del sistema a la imagen local
sudo systemctl reboot # arrancar con la nueva imagen
```

Actualizaciones posteriores (rebuild + upgrade):

```bash
just upgrade-system   # build + bootc upgrade
sudo systemctl reboot
```

### 4. Setup del entorno de usuario

Tras arrancar con la imagen ya rebajada:

```bash
just setup            # gnome settings, flatpaks, distrobox, dotfiles
just dotfiles         # solo los symlinks (si solo quieres re-enlazar)
just clone-repositories
```

### Comandos bootc disponibles

- `just bootc-build` — construye imagen local desde `Containerfile` (tag `YYYYMMDD` + `latest`).
- `just bootc-switch` — primer rebase del sistema a la imagen local.
- `just upgrade-system` — rebuild + `bootc upgrade` (uso habitual).
- `just bootc-status` — estado del deployment actual.
- `just bootc-rollback` — vuelve al deployment anterior.
- `just bootc-images` — lista imágenes locales del workstation.
- `just bootc-prune` — borra tags antiguos (mantiene `latest` y el del día).

### Comandos de setup y mantenimiento

- `just setup` — bootstrap completo (gnome + flatpaks + distrobox + dotfiles).
- `just upgrade` — actualiza paquetes en distrobox + flatpak + plugins nvim.
- `just dotfiles` — recrea symlinks de `config/*` a `$HOME` (idempotente).
- `just clone-repositories` — clona repos auxiliares en `$HOME/Code`.
- `just upgrade-archlinux` — `pacman -Syu` dentro del distrobox arch.
- `just upgrade-flatpak` — actualiza todos los flatpaks.
- `just nvim-upgrade-plugins` — actualiza plugins lazy.nvim.
- `just backup` — monta disco de backup y lista contenido.

### Nix (opcional en Linux)

- `just nix-install` — primer install de home-manager.
- `just nix-switch` — aplica configuración del flake (`.#linux`).
- `just nix-upgrade` — actualiza flake + reaplica.
- `just nix-clean` — recolector de basura.
- `just nix-packages` / `just nix-news` — info.

---

## MAC OS

En macOS no hay bootc. El flujo es Homebrew + Nix Home Manager.

### 1. Clonar repositorio

```bash
mkdir -p ~/Code
cd ~/Code
git clone https://github.com/mlophez/settings.git Workstation
cd Workstation
```

### 2. Instalar Homebrew y apps gráficas

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install --cask container
container system start

brew tap FelixKratz/formulae
brew install sketchybar

brew install --cask spaceid raycast

brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

### 3. Instalar Nix (Determinate) y home-manager

```bash
nix run home-manager/master -- --extra-experimental-features "nix-command flakes" switch --flake .#macos --impure
```

### 4. Setup

```bash
just setup            # delega en mac-setup (nix-install)
just dotfiles
```

### Comandos macOS

- `just setup` — bootstrap (nix-install).
- `just upgrade` — `nix-upgrade` + plugins nvim.
- `just dotfiles` — symlinks de `config/*` (incluye duplicados en `~/Library/Application Support/` para k9s/ngrok).
- `just clean` — limpia cachés (navegadores, Go, Poetry, Homebrew, Gradle, Podman, Terraform, Claude vm_bundles).
- `just nix-switch` / `just nix-upgrade` / `just nix-clean` — gestión Home Manager.

### Netskope (entorno corporativo Logalty)

```bash
security find-certificate -a -p /System/Library/Keychains/SystemRootCertificates.keychain > ~/system-ca.pem
security find-certificate -a -p /Library/Keychains/System.keychain >> ~/system-ca.pem

CACERTS="$(dirname $(readlink -f $(which java)))/../lib/security/cacerts"
cp $CACERTS ~/.local/share/certificates/netskope.jks
keytool -importcert \
  -trustcacerts \
  -alias netskope \
  -file ~/.local/share/certificates/netskope.ca.pem \
  -keystore ~/.local/share/certificates/netskope.jks \
  -storepass changeit

# DBeaver: añadir el JKS a /Applications/DBeaver.app/Contents/Eclipse/dbeaver.ini
#   -Djavax.net.ssl.trustStore=/Users/miguel.lopez/.local/share/certificates/netskope.jks
#   -Djavax.net.ssl.trustStorePassword=changeit
```

### Flutter / Android (opcional)

```bash
xcode-select --install
sudo xcodebuild -license accept
```

En Linux: `just linux-setup-flutter-development`.

---

## Comandos transversales

- `just claude-install` — instala Claude Code CLI.
- `just claude-setup` — instala el plugin marketplace caveman.
- `just kiro-install` — instala Kiro CLI.
- `just` (sin args) — lista todas las recetas disponibles.

---

## Convenciones para extender

- **App nueva de usuario:** crear `config/<app>/` y añadir la línea `install` en la receta `dotfiles` del `Justfile`.
- **Config de sistema:** colocarla bajo `default/` replicando la ruta de `/etc/` (ej. `default/ssh/sshd_config` → `/etc/ssh/sshd_config`).
- **Script nuevo:** colocarlo en `bin/`, `chmod +x` y añadir el enlace en `dotfiles`.
- **Paquete extra en imagen Linux:** editar `Containerfile` (raíz), añadir `RUN dnf5 install -y <pkg> && dnf5 clean all`, luego `just upgrade-system` + reboot.
- **Paquete CLI cross-platform:** editar `nix/linux.nix` o `nix/macos.nix` y `just nix-switch`.
