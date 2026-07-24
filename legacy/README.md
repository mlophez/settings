# Legacy — flujo bootc / ublue (Bluefin)

Aquí vive el flujo anterior de la workstation, basado en una imagen OCI **bootc**
derivada de `ghcr.io/ublue-os/bluefin:gts` (modelo *image-based OS* inmutable).

Se conserva **solo como referencia histórica**. El sistema actual es Fedora KDE
Plasma **mutable** (DNF5 + Btrfs/Snapper + systemd-boot); ver `docs/design.md` y
`docs/install.md`.

## Contenido

- `Containerfile` — derivación bootc desde Bluefin GTS (wezterm vía COPR, COSMIC comentado).
- `system.just` — recetas bootc: `build`, `switch`, `upgrade`, `status`, `rollback`,
  `list-images`, `prune-images`.

## Reactivarlo (no recomendado)

Estas recetas **no se importan** desde el `Justfile` raíz. Para volver a usarlas:

1. Añadir `import 'legacy/system.just'` en el `Justfile` raíz.
2. Las recetas construyen desde `legacy/Containerfile` y usan la variable `image`
   definida en el `Justfile` raíz.
