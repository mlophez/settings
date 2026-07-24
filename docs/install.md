# Instalación desde cero — Fedora KDE Plasma

Runbook reproducible de la workstation según `docs/design.md`: Fedora KDE Plasma
**mutable**, UEFI + systemd-boot, Btrfs con subvolúmenes y snapshots vía Snapper,
gestión de paquetes con DNF5 y datos separados del sistema en `/srv`.

El objetivo (ver `docs/design.md`) es que el sistema operativo sea reemplazable:
reinstalar Fedora debe preservar `home`, `srv` y los snapshots.

> Datos verificados a fecha de este documento: **Fedora 44** (estable desde
> 2026-04-28), KDE Plasma 6.6, DNF5. Ajustar versiones/comandos si cambia la release.

---

## 0. Requisitos previos

- Medio de instalación de **Fedora KDE Plasma** (Live USB). Descarga: <https://fedoraproject.org/kde/>
- Arranque en modo **UEFI** (no legacy/CSM).
- Segundo Live USB o medio de rescate a mano: la migración a systemd-boot puede
  dejar el sistema sin arrancar si algo falla.
- Copia de seguridad de cualquier dato previo en el disco de destino.

---

## 1. Particionado

Esquema objetivo (`docs/design.md`): sistema **sin cifrar**, `/home` opcionalmente
con fscrypt.

```
EFI    → FAT32   (ESP)
boot   → vfat    (ver aviso systemd-boot más abajo)
sistema→ Btrfs
```

> **Aviso systemd-boot / `/boot`:** systemd-boot solo lee kernels y entradas BLS
> desde la ESP o desde una partición **XBOOTLDR en VFAT**. Un `/boot` en ext4 no lo
> lee systemd-boot. Opciones:
> - `/boot` como VFAT marcada como XBOOTLDR (GPT type `bc13c2ff-59e6-4262-a352-b275fd6f7172`), o
> - una única ESP FAT32 suficientemente grande (p. ej. 1–2 GiB) sin `/boot` separado.
>
> `docs/design.md` propone `/boot` en ext4; reconciliar antes de instalar si se quiere
> systemd-boot. Este runbook asume `/boot` en VFAT (XBOOTLDR) o ESP única.

Crear las particiones (ejemplo con `/dev/nvme0n1`, ajustar dispositivo):

```bash
# ESP (~1 GiB), FAT32
# Btrfs para el resto del disco
# Si se usa /boot separado: partición VFAT tipo XBOOTLDR
```

Formatear:

```bash
mkfs.fat -F32 /dev/nvme0n1p1          # ESP
mkfs.btrfs -L fedora /dev/nvme0n1p2   # sistema
```

---

## 2. Subvolúmenes Btrfs y puntos de montaje

Montar la raíz Btrfs y crear los subvolúmenes (`docs/design.md`):

```bash
mount /dev/nvme0n1p2 /mnt
btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/home
btrfs subvolume create /mnt/srv
btrfs subvolume create /mnt/var-log
btrfs subvolume create /mnt/var-cache
btrfs subvolume create /mnt/var-tmp
btrfs subvolume create /mnt/snapshots
umount /mnt
```

Puntos de montaje:

| Subvolumen | Montaje      |
|------------|--------------|
| root       | `/`          |
| home       | `/home`      |
| srv        | `/srv`       |
| var-log    | `/var/log`   |
| var-cache  | `/var/cache` |
| var-tmp    | `/var/tmp`   |
| snapshots  | `/.snapshots`|

Además `/tmp` → **tmpfs**.

`fstab` de referencia (sustituir `UUID=...` por el de la partición Btrfs; opciones
`compress=zstd:1,noatime,ssd`):

```
UUID=<btrfs>  /            btrfs  subvol=root,compress=zstd:1,noatime  0 0
UUID=<btrfs>  /home        btrfs  subvol=home,compress=zstd:1,noatime  0 0
UUID=<btrfs>  /srv         btrfs  subvol=srv,compress=zstd:1,noatime   0 0
UUID=<btrfs>  /var/log     btrfs  subvol=var-log,compress=zstd:1,noatime 0 0
UUID=<btrfs>  /var/cache   btrfs  subvol=var-cache,compress=zstd:1,noatime 0 0
UUID=<btrfs>  /var/tmp     btrfs  subvol=var-tmp,compress=zstd:1,noatime 0 0
UUID=<btrfs>  /.snapshots  btrfs  subvol=snapshots,compress=zstd:1,noatime 0 0
UUID=<esp>    /boot/efi    vfat   umask=0077,shortname=winnt           0 2
tmpfs         /tmp         tmpfs  defaults,noatime,mode=1777           0 0
```

**Snapshots (`docs/design.md`):** incluyen solo el estado del sistema (subvolumen
`root`). Quedan **excluidos** `/srv`, `/var/log`, `/var/cache`, `/var/tmp`, `/tmp`
al vivir en subvolúmenes propios: un snapshot de `root` no los arrastra.

---

## 3. Instalación base de Fedora KDE

Opción A (recomendada, sencilla): instalar con el instalador **Anaconda** de la Live
de Fedora KDE eligiendo particionado manual y asignando los subvolúmenes/montajes de
la sección 2. Anaconda deja GRUB por defecto; la sección 4 lo migra a systemd-boot.

Opción B (manual): `dnf --installroot` / bootstrap manual montando los subvolúmenes.
Más control, más pasos; solo si se necesita.

Tras la instalación y primer arranque, actualizar:

```bash
sudo dnf5 upgrade --refresh
sudo systemctl reboot
```

---

## 4. Bootloader: migrar de GRUB a systemd-boot

`docs/design.md` fija UEFI + systemd-boot + Boot Loader Specification (BLS).

> **Peligro:** reconfigurar el bootloader puede dejar el sistema sin arrancar. Tener
> el Live USB de rescate a mano y una copia de la ESP.

```bash
# 1. Quitar GRUB y su gestor de entradas
sudo dnf5 remove -y grubby grub2\* memtest86\*

# 2. Instalar systemd-boot y sdubby (sustituye a grubby)
sudo dnf5 install -y systemd-boot-unsigned sdubby

# 3. Revisar dónde colocará kernel-install las entradas (layout bls, boot root)
kernel-install inspect

# 4. Instalar systemd-boot en la ESP (usar --esp-path si no es la ruta estándar)
sudo bootctl install
# o: sudo bootctl --esp-path=/boot/efi install

# 5. Verificar que existen entradas BLS para todos los kernels
ls /boot/loader/entries/
cat /boot/loader/entries/*.conf

# 6. (Opcional) Eliminar la entrada EFI de GRUB del firmware
sudo efibootmgr            # localizar la entrada de GRUB (Boot####)
sudo efibootmgr -b <XXXX> -B
```

Una entrada BLS válida contiene `title`, `version`, `linux /vmlinuz-...`,
`initrd /initramfs-...img` y `options root=UUID=... ro`. Si el menú aparece vacío,
casi siempre son entradas BLS ausentes o mal formadas: regenerar con
`sudo kernel-install add <version> /lib/modules/<version>/vmlinuz`.

---

## 5. Snapshots: Snapper + DNF5

`docs/design.md`: snapshot **antes** y **después** de cada `dnf upgrade`, sobre el
subvolumen `root`. La instalación de paquetes se hace con `just upgrade` / `just install`
(que solo lanzan DNF5); los snapshots los gestiona un **script propio** enganchado a
cada transacción vía el plugin de acciones de libdnf5.

> Con DNF5 el antiguo plugin `python3-dnf-plugin-snapper` ya no aplica: la integración
> es `libdnf5-plugin-actions`.

```bash
# Paquetes
sudo dnf5 install -y snapper libdnf5-plugin-actions

# Config de Snapper para el subvolumen root
sudo snapper -c root create-config /

# Timers de timeline y limpieza (retención automática)
sudo systemctl enable --now snapper-timeline.timer
sudo systemctl enable --now snapper-cleanup.timer
```

**Hook DNF5 → snapshots (el "script propio").** Crear scripts pre/post en
`/usr/local/bin/` (que hacen `snapper -c root create -t pre|post ...` y guardan el
número del snapshot pre para emparejarlo con el post) y declararlos en
`/etc/dnf/libdnf5-plugins/actions.d/snapper.actions`. Formato del fichero de acciones:

```
# Crear snapshot PRE antes de la transacción
pre_transaction::::/usr/local/bin/snapper-pre.sh ${pid}
# Crear snapshot POST tras la transacción
post_transaction::::/usr/local/bin/snapper-post.sh ${pid}
```

> **Fix WAL importante:** desde Fedora 44 PackageKit usa el backend DNF5/libdnf5, lo
> que introduce una inconsistencia de la base de datos RPM (SQLite WAL) que rompe el
> rollback si no se aplica un checkpoint tras la transacción. El script `post` debe
> incluir el fix. Setup automatizado y probado (incluye el fix WAL):
> <https://github.com/SysGuides/sysguides-snapper-fedora>.

**Rollback de sistema** (revertir cambios entre dos snapshots):

```bash
snapper -c root list
sudo snapper -c root undochange <pre>..<post>
```

**Rollback de paquetes vía DNF** (alternativa/independiente de los snapshots):

```bash
sudo dnf5 history list
sudo dnf5 history undo <id>
```

> **Arranque en un snapshot desde systemd-boot:** no hay herramienta estándar
> (grub-btrfs es solo para GRUB). Generar la entrada de systemd-boot para arrancar un
> snapshot es un paso manual / script propio pendiente (ver `docs/design.md`, sección Boot).

---

## 6. Entorno de usuario (este repositorio)

Con el sistema base arrancando, clonar el repo y montar el entorno. Ver `README.md`
para el detalle de cada receta.

```bash
mkdir -p ~/Code && cd ~/Code
git clone https://github.com/mlophez/settings.git Workstation
cd Workstation

# Symlinks de dotfiles (config/*, bin/*) a $HOME
just config

# Bootstrap completo: apps flatpak + distrobox + dotfiles (+ GNOME, inerte en KDE)
just install-all

# Herramientas CLI cross-platform vía Nix Home Manager (opcional)
just nix-install

# Contenedor archlinux para herramientas no disponibles en el host
just distrobox-setup

# Repos de trabajo
just config-repositories
```

Herramientas del host que no vengan por defecto: `just install <paquete>` (DNF5).

KDE guarda su configuración en `~/.config` y `~/.local/share`. La captura/versionado
de la config KDE es un paso pendiente (el repo aún versiona la config GNOME previa);
por ahora se configura a mano tras la instalación.

---

## 7. Datos y contenedores

`docs/design.md`: los datos persistentes viven **siempre** en `/srv`, nunca en
`/var/lib/containers`.

- **Desarrollo:** Podman rootless; imágenes en `~/.local/share/containers`.
- **Producción / Home Lab:** montar los volúmenes persistentes desde `/srv`
  (`/srv/podman`, `/srv/media`, `/srv/backups`, servicios como immich, jellyfin,
  nextcloud, postgres, paperless...).

---

## 8. Reinstalación preservando datos

`docs/design.md`: **no** formatear el Btrfs. Eliminar únicamente el subvolumen `root`
y reinstalar montando los subvolúmenes existentes.

```bash
# Desde el Live USB, montar la raíz Btrfs
mount /dev/nvme0n1p2 /mnt

# Borrar SOLO el subvolumen del sistema
btrfs subvolume delete /mnt/root
btrfs subvolume create /mnt/root

# Conservar: home, srv, snapshots
umount /mnt
```

Después reinstalar Fedora (sección 3) montando los subvolúmenes existentes, repetir
la migración a systemd-boot (sección 4) y Snapper (sección 5), y re-montar el entorno
de usuario (sección 6). `home` y `srv` quedan intactos.

---

## Referencias

- `docs/design.md` — objetivos y decisiones de diseño.
- Migrar a systemd-boot en Fedora: <https://discussion.fedoraproject.org/t/migrating-fedora-44-from-grub-to-systemd-boot/190312>
- Snapper + Btrfs + DNF5 en Fedora 44: <https://sysguides.com/fedora-44-with-btrfs-snapshot-and-rollback-support>
- Setup automatizado Snapper (con fix WAL): <https://github.com/SysGuides/sysguides-snapper-fedora>
