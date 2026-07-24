# Fedora KDE Workstation Design

## Objetivos

- Fedora KDE Plasma (no inmutable).
- UEFI + systemd-boot.
- Btrfs con Snapper.
- Rollback completo del sistema mediante snapshots.
- Rollback de paquetes mediante DNF.
- Sistema fácilmente reinstalable.
- Separar completamente el sistema de los datos.
- Configuración reproducible desde Git.
- Preparado para evolucionar a Home Lab.

---

# Boot

- UEFI
- systemd-boot
- Boot Loader Specification (BLS)

En cada actualización:

1. Snapshot antes de actualizar.
2. `dnf upgrade`.
3. Snapshot después de actualizar.
4. Generar entrada de systemd-boot para arrancar snapshots.

---

# Sistema de archivos

## Particiones

```
EFI
/boot
Btrfs
```

### EFI

```
FAT32
```

### Boot

```
ext4
```

### Sistema

```
Btrfs
```

---

# Cifrado

No cifrar el sistema.

Opcionalmente:

- `/home` con fscrypt.
- Desbloqueo mediante login.
- Protección ante robo del equipo.
- Menor complejidad que cifrar todo el disco.

---

# Subvolúmenes

```
root
home
srv
var-log
var-cache
var-tmp
snapshots
```

---

# Puntos de montaje

| Subvolumen | Montaje |
|------------|----------|
| root | / |
| home | /home |
| srv | /srv |
| var-log | /var/log |
| var-cache | /var/cache |
| var-tmp | /var/tmp |
| snapshots | /.snapshots |

Además:

```
/tmp -> tmpfs
```

---

# Snapshots

Incluir:

- root

Excluir:

- /srv
- /var/log
- /var/cache
- /var/tmp
- /tmp

Los snapshots deben representar únicamente el estado del sistema.

---

# Organización de /srv

```
/srv
├── podman/
├── media/
├── backups/
├── shares/
└── services/
```

o bien

```
/srv
├── immich/
├── jellyfin/
├── nextcloud/
├── postgres/
└── paperless/
```

Los datos persistentes siempre deben vivir en `/srv`.

---

# Contenedores

## Desarrollo

Podman rootless.

Imágenes:

```
~/.local/share/containers
```

## Producción/Home Lab

Los datos persistentes se montarán desde:

```
/srv
```

Nunca desde:

```
/var/lib/containers
```

---

# Gestión de paquetes

- DNF5
- Historial de transacciones
- Snapshots automáticos
- Scripts propios para instalación
- Sin Ansible

---

# Configuración

Versionar en Git:

```
dotfiles/
├── install.sh
├── fstab
├── systemd/
├── snapper/
├── boot/
├── kde/
└── scripts/
```

Guardar:

- configuración KDE
- systemd
- Snapper
- systemd-boot
- scripts de instalación

---

# KDE

Versionar principalmente:

```
~/.config
~/.local/share
```

---

# Reinstalación

No formatear Btrfs.

Eliminar únicamente:

```
root
```

Mantener:

```
home
srv
snapshots
```

Después reinstalar Fedora montando los subvolúmenes existentes.

---

# Filosofía

El sistema operativo debe ser completamente reemplazable.

Los datos nunca deben depender del sistema operativo.

Todo cambio importante debe poder revertirse mediante snapshots.

La configuración debe poder reconstruirse desde Git en una instalación limpia.

El objetivo es que reinstalar Fedora sea una operación sencilla que preserve todos los datos y la configuración importante.
