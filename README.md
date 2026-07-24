# WORKSTATION

Repositorio personal de configuración versionada de la workstation (Linux y macOS) de Miguel.

No es código de aplicación: contiene dotfiles, configuración y un orquestador en `just`
para reconstruir todo el entorno desde cero en una máquina nueva.

## Para qué sirve

- **Linux (Fedora KDE Plasma, mutable):** Fedora KDE sobre Btrfs con snapshots (Snapper),
  UEFI + systemd-boot y gestión de paquetes con DNF5. Apps gráficas vía Flatpak,
  herramientas CLI vía DNF nativo, distrobox archlinux y/o Nix Home Manager. Los datos
  persistentes viven en `/srv`, separados del sistema. Ver `docs/design.md` (diseño) y
  `docs/install.md` (instalación paso a paso).
- **macOS:** paquetes CLI vía Nix Home Manager + apps gráficas vía Homebrew.
- **Ambas plataformas:** enlazar todos los dotfiles (`config/*`) y scripts (`bin/*`)
  mediante symlinks idempotentes al `$HOME` correspondiente.

> El flujo anterior estaba basado en una imagen bootc inmutable derivada de Bluefin/ublue.
> Se conserva, sin uso, en `legacy/` (ver `legacy/README.md`).

## Arquitectura

Jerarquías versionadas, mapeadas al sistema mediante symlinks creados por `just config`:

- `config/` → dotfiles de usuario (enlazados a `$HOME` y `~/.config/<app>`).
- `bin/` → scripts ejecutables del usuario (enlazados a `$HOME/.local/bin/<script>`).
- `default/` → configuración de sistema (`/etc/<path>`), cuando exista.

Además:
- `flake.nix` + `nix/` → configuración Home Manager para `linux` y `macos`.
- `Justfile` → orquestador; las recetas viven en `just/*.just`, importadas por sección.
- `legacy/` → flujo bootc/ublue anterior (no importado; solo referencia).
- `docs/` → diseño (`design.md`) e instalación (`install.md`).

---

## LINUX (Fedora KDE Plasma)

### 1. Instalación del sistema base

La instalación desde cero (particionado Btrfs + subvolúmenes, systemd-boot, Snapper +
DNF5) está documentada paso a paso en **`docs/install.md`**. El diseño y sus decisiones,
en **`docs/design.md`**.

### 2. Clonar este repositorio

```bash
mkdir -p ~/Code && cd ~/Code
git clone https://github.com/mlophez/settings.git Workstation
cd Workstation
```

### 3. Montar el entorno de usuario

```bash
just config              # symlinks de config/* y bin/* a $HOME (idempotente)
just install-all         # bootstrap: apps flatpak + distrobox + dotfiles (+ GNOME, inerte en KDE)
just nix-install         # opcional: herramientas CLI cross-platform vía Nix
just distrobox-setup     # contenedor archlinux para herramientas no disponibles en el host
just config-repositories # clona los repos de trabajo en ~/Code
```

### Uso habitual

- `just upgrade` — actualiza los paquetes del host (`dnf5 upgrade`), envuelto por el
  script `bin/snapshot` en un par de snapshots pre/post de Snapper (ver `docs/install.md`).
- `just install <pkg>...` — instala paquetes del host (`dnf5 install`), también con snapshots.
- `just upgrade-all` — actualiza todo el entorno de terminal: host (dnf) + distrobox +
  flatpak + plugins de nvim.
- `just config` — recrea los symlinks de `config/*` y `bin/*`.
- `just clean-cache` — limpia cachés para liberar disco.

### Recetas por grupo

- **Distrobox:** `distrobox-setup` (`dx-setup`), `distrobox-init`, `distrobox-install`,
  `distrobox-upgrade`, `distrobox-config`.
- **Nix (opcional):** `nix-install`, `nix-switch`, `nix-upgrade`, `nix-clean`,
  `nix-packages`, `nix-news`.
- **GNOME (config previa; inerte en KDE):** `gnome-load-config`, `gnome-save-config`,
  `gnome-load-keybinds`.
- **Backup:** `backup-to-disk`.

---

## MACOS

En macOS el flujo es Homebrew + Nix Home Manager.

### 1. Clonar repositorio

```bash
mkdir -p ~/Code && cd ~/Code
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

### 3. Instalar Nix (Determinate) y home-manager + setup

```bash
just install-all         # delega en nix-install (home-manager switch .#macos)
just config              # symlinks de config/* (incluye duplicados en ~/Library/Application Support/)
```

### Uso habitual (macOS)

- `just upgrade-all` — `nix-upgrade` + plugins de nvim.
- `just config` — recrea symlinks.
- `just clean-cache` — limpia cachés (navegadores, Go, Poetry, Homebrew, Gradle, Podman, Terraform, Claude vm_bundles).
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

En Linux: `just install-flutter`.

---

## Comandos transversales

- `just` (sin args) — lista todas las recetas disponibles.
- `just install-claude` — instala Claude Code CLI.
- `just config-claude` — instala el plugin marketplace caveman.
- `just install-kiro` / `just install-devbox` / `just install-harlequin`.
- `just download-resources` — clona repos de referencia en `resources/` (ignorado por git).

---

## Convenciones para extender

- **App nueva de usuario:** crear `config/<app>/` y añadir la línea `link` en la receta
  `config` (`just/settings.just`).
- **Script nuevo:** colocarlo en `bin/`, `chmod +x` y enlazarlo desde `config`.
- **Config de sistema:** bajo `default/` replicando la ruta de `/etc/`.
- **Receta nueva:** crear `just/<sección>.just` (o añadirla al grupo correspondiente) y,
  si es un fichero nuevo, importarla en el `Justfile` raíz.
- **Paquete del host Linux:** `just install <pkg>` (DNF5). Snapshots pre/post vía el
  script `bin/snapshot`.
- **Paquete CLI cross-platform:** editar `nix/linux.nix` o `nix/macos.nix` y `just nix-switch`.
